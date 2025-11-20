import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/custom_image_picker.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/main.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

class AccountBloc {
  late BuildContext context;

  AccountBloc(BuildContext context) {
    this.context = context;
    _loadingController.add(false);
  }

  // Stream controllers
  final _userInfoController = StreamController<UserMeResModel>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();

  // Streams
  Stream<UserMeResModel> get userInfoStream => _userInfoController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  // Current user cache
  UserMeResModel? _currentUser;
  UserMeResModel? get currentUser => _currentUser;

  // Pending avatar (not yet saved)
  String? _pendingAvatar;
  String? get pendingAvatar => _pendingAvatar;

  void setPendingAvatar(String? avatar) {
    _pendingAvatar = avatar;
  }

  void clearPendingAvatar() {
    _pendingAvatar = null;
  }

  /// Initialize with user data
  void setUserInfo(UserMeResModel user) {
    _currentUser = user;
    _userInfoController.add(user);
  }

  /// Logout user
  Future<void> onLogOut(BuildContext context) async {
    _loadingController.add(true);
    GoMepLoadingDialog.show(context);
    await Future.delayed(const Duration(seconds: 1));

    GoMepLoadingDialog.hide(context);
    _loadingController.add(false);

    Globals.prefs.dispose();
    DraggableStackService().updateIsShowDraggableStack(false);
    CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
  }

  /// Update user profile - saves to local database only
  Future<UserMeResModel?> updateProfile({
    required String fullName,
    required String dateOfBirth,
    required String address,
  }) async {
    if (_currentUser == null) return null;

    _loadingController.add(true);
    GoMepLoadingDialog.show(context);

    try {
      // Update current user with new values
      _currentUser!.fullName = fullName;
      _currentUser!.dateOfBirth = dateOfBirth;
      _currentUser!.address = address;

      // Apply pending avatar if exists
      if (_pendingAvatar != null) {
        _currentUser!.avatar = _pendingAvatar;
        _pendingAvatar = null;
      }

      // Save to local database
      await Globals.userRepository?.cacheUser(_currentUser!);

      // Emit updated user to stream
      _userInfoController.add(_currentUser!);

      GoMepLoadingDialog.hide(context);
      _loadingController.add(false);

      return _currentUser;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      GoMepLoadingDialog.hide(context);
      _loadingController.add(false);
      return null;
    }
  }

  /// Set pending avatar (not saved until updateProfile is called)
  String? setAvatarFromBytes(Uint8List imageBytes) {
    try {
      // Convert image to base64
      final base64Image = base64Encode(imageBytes);
      _pendingAvatar = 'data:image/png;base64,$base64Image';
      return _pendingAvatar;
    } catch (e) {
      debugPrint('Error converting avatar: $e');
      return null;
    }
  }

  /// Show image picker for avatar - sets pending avatar for preview
  void pickAndUploadAvatar({Function(String)? onAvatarSelected}) {
    CustomImagePicker.showPicker(
      context,
      (imageBytes) {
        final avatarData = setAvatarFromBytes(imageBytes);
        if (avatarData != null) {
          onAvatarSelected?.call(avatarData);
        } else {
          Utility.toast('Đã có lỗi xảy ra khi tải ảnh lên');
        }
      },
      isSelfie: true,
    );
  }

  void dispose() {
    _userInfoController.close();
    _loadingController.close();
  }
}
