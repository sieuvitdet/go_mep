import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  late BuildContext context;

  final streamUserInfo = BehaviorSubject<UserMeResModel?>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamCurrentIndex = BehaviorSubject<int>();

  MainBloc(BuildContext context) {
    this.context = context;
    Globals.mainBloc = this;
    streamIsLoading.add(false);
    streamCurrentIndex.add(0);

    // Watch user from database (reactive!)
    _watchUserInfo();
  }

  /// Watch user info from database (auto-updates when user data changes!)
  void _watchUserInfo() {
    final repository = Globals.userRepository;
    if (repository != null) {
      repository.watchCurrentUser().listen((userEntity) {
        if (userEntity != null) {
          // Convert entity to model
          final userModel = UserMeResModel(
            id: userEntity.id,
            hashId: userEntity.hashId,
            phoneNumber: userEntity.phoneNumber,
            fullName: userEntity.fullName,
            dateOfBirth: userEntity.dateOfBirth,
            address: userEntity.address,
            userType: userEntity.userType,
            isActive: userEntity.isActive,
            isSuperuser: userEntity.isSuperuser,
          );

          streamUserInfo.add(userModel);
          Globals.userMeResModel = userModel;
        }
      });
    }
  }

  /// Get user info with cache-first strategy
  ///
  /// Strategy:
  /// 1. Load from cache first (instant display)
  /// 2. Check if cache is stale (> 24 hours)
  /// 3. If stale or force refresh, fetch from API
  /// 4. Update cache with fresh data
  /// 5. If offline, use cached data
  Future<void> getUserInfo({bool forceRefresh = false}) async {
    streamIsLoading.add(true);

    final repository = Globals.userRepository;
    if (repository == null) {
      debugPrint('❌ UserRepository not initialized');
      streamIsLoading.add(false);
      return;
    }

    try {
      // Step 1: Load from cache first (if not force refresh)
      if (!forceRefresh) {
        final cached = await repository.getCachedUser();
        if (cached != null) {
          streamUserInfo.add(cached);
          Globals.userMeResModel = cached;
          debugPrint('📱 Loaded user from cache: ${cached.fullName}');
        }
      }

      // Step 2: Fetch from API (with cache-first strategy in repository)
      final userModel = await repository.getUser(
        context: context,
        forceRefresh: forceRefresh,
      );

      if (userModel != null) {
        streamUserInfo.add(userModel);
        Globals.userMeResModel = userModel;
        debugPrint('✅ Loaded user from API: ${userModel.fullName}');
      } else {
        // If API failed, try cache one more time
        final cached = await repository.getCachedUser();
        if (cached != null) {
          streamUserInfo.add(cached);
          Globals.userMeResModel = cached;
          debugPrint('📱 Using cached user (API failed): ${cached.fullName}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading user info: $e');

      // On error, try to use cache
      final cached = await repository.getCachedUser();
      if (cached != null) {
        streamUserInfo.add(cached);
        Globals.userMeResModel = cached;
        debugPrint('📱 Using cached user (exception): ${cached.fullName}');
      }
    } finally {
      streamIsLoading.add(false);
    }
  }

  /// Refresh user info (force fetch from API)
  Future<void> refreshUserInfo() async {
    await getUserInfo(forceRefresh: true);
  }

  /// Clear user cache (on logout)
  Future<void> clearUserCache() async {
    final repository = Globals.userRepository;
    if (repository != null) {
      await repository.clearCache();
      streamUserInfo.add(null);
      Globals.userMeResModel = null;
      debugPrint('🗑️ User cache cleared');
    }
  }

  /// Check if user cache is stale
  Future<bool> isUserCacheStale() async {
    final repository = Globals.userRepository;
    if (repository == null) return true;

    return await repository.isUserCacheStale();
  }

  void dispose() {
    streamUserInfo.close();
    streamIsLoading.close();
    streamCurrentIndex.close();
  }
}
