import 'dart:ui';

import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs.dart';

import 'config.dart';

class Globals {
  static late SharedPrefs prefs;
  static late Locale locale;
  static late LocaleType localeType;
  static late Config config;
  static late String applicationMode;
  static bool connectFail = false;
  static bool alreadyShowPopupExpired = false;
  static GlobalKey? myApp;
  static MainBloc? mainBloc;
  static UserMeResModel? userMeResModel;
}
