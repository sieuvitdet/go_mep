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
  }

  Future<void> getUserInfo() async {
    streamIsLoading.add(true);

    UserMeResModel user = UserMeResModel(
      address: "15/02 Công Quỳnh phường Nguyễn Cư Trinh\nQuận 1 Thành phố Hồ Chí Minh",
      phoneNumber: "0778393935",
      fullName: "Anh tên Long, xăm cc trên mông",
      birthday: "09-03-1983",
      gender: "Nữ",
      email: "leovu@gmail.com",
      username: "longvu",
      id: "1234567890",
      note: "Tôi là một người yêu thích các hoạt động ngoại khóa và thể thao.");
    streamUserInfo.add(user);
    Globals.userMeResModel = user;

    // ResponseModel responseModel = await Repository.getUserMe(context);

    // if (responseModel.success ?? false) {
    //   UserMeResModel userMeResModel =
    //       UserMeResModel.fromJson(responseModel.result ?? {});
    //   streamUserInfo.add(userMeResModel);
    //   Globals.userMeResModel = userMeResModel;
    // }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamUserInfo.close();
    streamIsLoading.close();
    streamCurrentIndex.close();
  }
}
