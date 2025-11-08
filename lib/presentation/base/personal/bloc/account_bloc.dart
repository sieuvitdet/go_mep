import 'dart:async';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
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

    await Repository.logout(context);

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

  void dispose() {
    _userInfoController.close();
    _loadingController.close();
  }
}
