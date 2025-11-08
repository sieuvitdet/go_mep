import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/net/http/http_connection.dart';
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
  }

  Future<void> getUserInfo() async {
    streamIsLoading.add(true);

    try {
      ResponseModel responseModel = await Repository.getUserMe(context);
      UserMeResModel userMeResModel = UserMeResModel(
        id: 1,
        hashId: "1",
        phoneNumber: "03456987189",
        fullName: "Duc Tran",
        dateOfBirth: "1990-01-01",
        address: "100 P. Đông Các, Đống Đa, Đống Đa, Hà Nội",
        userType: "user",
        isActive: true,
        isSuperuser: false,
      );
      streamUserInfo.add(userMeResModel);
      Globals.userMeResModel = userMeResModel;

      // if (responseModel.success ?? false) {
      //   UserMeResModel userMeResModel =
      //       UserMeResModel.fromJson(responseModel.result ?? {});
      //   streamUserInfo.add(userMeResModel);
      //   Globals.userMeResModel = userMeResModel;
      // }
    } catch (e) {
    }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamUserInfo.close();
    streamIsLoading.close();
    streamCurrentIndex.close();
  }
}
