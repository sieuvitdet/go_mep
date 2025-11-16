import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs.dart';
import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/repositories/notification_repository.dart';
import 'package:go_mep_application/data/repositories/user_repository.dart';
import 'package:go_mep_application/data/repositories/places_repository.dart';
import 'package:go_mep_application/data/repositories/auth_repository.dart';
import 'package:go_mep_application/data/repositories/waterlogging_repository.dart';
import 'package:go_mep_application/data/local/database/database_maintenance_service.dart';

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

  // Database and repositories
  static AppDatabase? database;
  static NotificationRepository? notificationRepository;
  static UserRepository? userRepository;
  static PlacesRepository? placesRepository;
  static AuthRepository? authRepository;
  static WaterloggingRepository? waterloggingRepository;
  static DatabaseMaintenanceService? maintenanceService;
}
