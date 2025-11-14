import 'package:flutter/material.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/user_dao.dart';
import '../model/res/user_me_res_model.dart';
import '../../net/repository/repository.dart';

/// Repository for managing user data with cache-first strategy
///
/// Strategy:
/// 1. Load from cache for instant display
/// 2. Check if cache is stale (older than 24 hours)
/// 3. If stale or force refresh, fetch from API
/// 4. Update cache with fresh data
/// 5. If offline, use cached data
class UserRepository {
  final UserDao _userDao;

  /// Cache validity duration (24 hours)
  static const Duration cacheValidity = Duration(hours: 24);

  UserRepository(this._userDao);

  /// Watch current user (reactive stream that auto-updates)
  Stream<UserEntity?> watchCurrentUser() {
    return _userDao.watchCurrentUser();
  }

  /// Get cached user (instant, no network)
  Future<UserMeResModel?> getCachedUser() async {
    final entity = await _userDao.getCurrentUser();
    if (entity == null) return null;
    return _entityToModel(entity);
  }

  /// Get user with cache-first strategy
  Future<UserMeResModel?> getUser({
    required BuildContext context,
    bool forceRefresh = false,
  }) async {
    // Check if we should use cache
    if (!forceRefresh) {
      final isStale = await _userDao.isUserDataStale(cacheValidity);

      if (!isStale) {
        // Cache is fresh, return it
        final cached = await getCachedUser();
        if (cached != null) {
          return cached;
        }
      }
    }

    // Fetch from API
    try {
      final response = await Repository.getUserMe(context);

      if (response != null && response.result != null) {
        final userModel = UserMeResModel.fromJson(response.result);

        // Cache the fresh data
        await cacheUser(userModel);

        return userModel;
      }

      // If API failed, return cached data
      return await getCachedUser();
    } catch (e) {
      debugPrint('Error fetching user from API: $e');
      // On error, return cached data
      return await getCachedUser();
    }
  }

  /// Fetch fresh user data from API and update cache
  Future<UserMeResModel?> fetchFreshUser({
    required BuildContext context,
  }) async {
    try {
      final response = await Repository.getUserMe(context);

      if (response != null && response.result != null) {
        final userModel = UserMeResModel.fromJson(response.result);

        // Update cache
        await cacheUser(userModel);

        return userModel;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching fresh user data: $e');
      return null;
    }
  }

  /// Cache user to local database
  Future<void> cacheUser(UserMeResModel user) async {
    final entity = _modelToEntity(user);
    await _userDao.upsertUser(entity);
  }

  /// Check if user data exists in cache
  Future<bool> hasUserCache() async {
    return await _userDao.hasUser();
  }

  /// Check if user cache is stale
  Future<bool> isUserCacheStale() async {
    return await _userDao.isUserDataStale(cacheValidity);
  }

  /// Clear user cache (on logout)
  Future<void> clearCache() async {
    await _userDao.deleteCurrentUser();
  }

  /// Update user information
  Future<UserMeResModel?> updateUserInfo({
    required String phoneNumber,
    required String fullName,
    String? dateOfBirth,
    String? address,
  }) async {
    try {
      // Get current user from database
      final currentUser = await _userDao.getUserByPhone(phoneNumber);
      if (currentUser == null) {
        debugPrint('User not found: $phoneNumber');
        return null;
      }

      // Update user entity with new information
      final updatedEntity = UserEntity(
        id: currentUser.id,
        hashId: currentUser.hashId,
        phoneNumber: currentUser.phoneNumber,
        fullName: fullName,
        dateOfBirth: dateOfBirth ?? currentUser.dateOfBirth,
        address: address ?? currentUser.address,
        avatar: currentUser.avatar,
        userType: currentUser.userType,
        isActive: currentUser.isActive,
        isSuperuser: currentUser.isSuperuser,
        updatedAt: DateTime.now(),
      );

      // Save to database
      await _userDao.upsertUser(updatedEntity);

      debugPrint('✅ User information updated: $fullName');

      return _entityToModel(updatedEntity);
    } catch (e) {
      debugPrint('❌ Error updating user info: $e');
      return null;
    }
  }

  // Helper methods to convert between Entity and Model

  UserMeResModel _entityToModel(UserEntity entity) {
    return UserMeResModel(
      id: entity.id,
      hashId: entity.hashId,
      phoneNumber: entity.phoneNumber,
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      address: entity.address,
      avatar: entity.avatar,
      userType: entity.userType,
      isActive: entity.isActive,
      isSuperuser: entity.isSuperuser,
    );
  }

  UserEntity _modelToEntity(UserMeResModel model) {
    return UserEntity(
      id: model.id ?? 0,
      hashId: model.hashId,
      phoneNumber: model.phoneNumber,
      fullName: model.fullName,
      dateOfBirth: model.dateOfBirth,
      address: model.address,
      avatar: model.avatar,
      userType: model.userType,
      isActive: model.isActive ?? true,
      isSuperuser: model.isSuperuser ?? false,
      updatedAt: DateTime.now(),
    );
  }
}
