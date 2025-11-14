import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/custom_image_picker.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/model/req/update_profile_req_model.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

class AccountBloc {
  late BuildContext context;
  UserMeResModel? _currentUser;
  
  AccountBloc(BuildContext context) {
    this.context = context;
    _loadingController.add(false);
  }

  final _userInfoController = StreamController<UserMeResModel?>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();

  Stream<UserMeResModel?> get userInfoStream => _userInfoController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void setUserInfo(UserMeResModel? user) {
    _currentUser = user;
    _userInfoController.add(user);
  }

  Future<void> onLogOut(BuildContext context) async {
    _loadingController.add(true);
    GoMepLoadingDialog.show(context);
    await Future.delayed(const Duration(seconds: 1));

    // await Repository.logout(context);

    GoMepLoadingDialog.hide(context);
    _loadingController.add(false);

    Globals.prefs.dispose();
    CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
  }

  Future<bool> updateProfile({
    required String fullName,
    required String dateOfBirth,
    required String address,
  }) async {
    _loadingController.add(true);
    GoMepLoadingDialog.show(context);

    UpdateProfileReqModel model = UpdateProfileReqModel(
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      address: address,
    );

    ResponseModel responseModel = await Repository.updateProfile(context, model);

    GoMepLoadingDialog.hide(context);
    _loadingController.add(false);

    if (responseModel.success ?? false) {
      // Cập nhật lại thông tin user sau khi update thành công
      if (responseModel.result != null && _currentUser != null) {
        final data = responseModel.result as Map<String, dynamic>;
        final updatedFields = data['updated_fields'] as Map<String, dynamic>?;

        if (updatedFields != null) {
          // Chỉ update 3 field mới từ response
          _currentUser!.fullName = updatedFields['full_name'];
          _currentUser!.dateOfBirth = updatedFields['date_of_birth'];
          _currentUser!.address = updatedFields['address'];

          // Set lại user info với các field đã được update
          setUserInfo(_currentUser);
        }
      }
      return true;
    }
    return false;
  }

  /// Upload avatar and update user profile
  Future<bool> uploadAvatar(Uint8List imageBytes) async {
    try {
      _loadingController.add(true);
      GoMepLoadingDialog.show(context);

      // Convert image to base64
      final base64Image = base64Encode(imageBytes);

      // For demo: Save directly to local database
      // In production: Upload to server first, then save URL
      if (_currentUser != null) {
        _currentUser!.avatar = 'data:image/png;base64,$base64Image';

        // Update cache
        await Globals.userRepository?.cacheUser(_currentUser!);

        // Update stream
        setUserInfo(_currentUser);

        GoMepLoadingDialog.hide(context);
        _loadingController.add(false);

        Utility.toast('Cập nhật ảnh đại diện thành công!');
        return true;
      }

      GoMepLoadingDialog.hide(context);
      _loadingController.add(false);
      return false;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      GoMepLoadingDialog.hide(context);
      _loadingController.add(false);
      Utility.toast('Đã có lỗi xảy ra khi tải ảnh lên');
      return false;
    }
  }

  /// Show image picker for avatar
  void pickAndUploadAvatar() {
    CustomImagePicker.showPicker(
      context,
      (imageBytes) async {
        await uploadAvatar(imageBytes);
      },
      isSelfie: true,
    );
  }

  void dispose() {
    _userInfoController.close();
    _loadingController.close();
  }
}
