import 'package:flutter/services.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class Config {
  static Future<void> getPreferences() async {
    await SharedPreferences.getInstance().then((event) async {
      Globals.prefs = SharedPrefs(event);
      dynamic jsonResult =
          Utility.stringToJson(await rootBundle.loadString(Assets.configJson));
      Globals.applicationMode = jsonResult["environment"];
      Globals.config = Config.fromJson(jsonResult[jsonResult["environment"]]);
      if ((Globals.config.langDefault ?? "").isNotEmpty) {
        LangKey.langDefault = Globals.config.langDefault!;
      }
    });
  }

  String? langDefault;
  String? releaseDate;
  bool? displayPrint;
  String? appId;
  String? appName;
  String? server;
  String? serverLogin;
  String? versionName;

  Config(
      {this.langDefault,
      this.releaseDate,
      this.displayPrint,
      this.appId,
      this.appName,
      this.server,
      this.serverLogin,
      this.versionName});

  Config.fromJson(Map<String, dynamic> json) {
    langDefault = json['langDefault'];
    releaseDate = json['releaseDate'];
    displayPrint = json['displayPrint'] ?? false;
    appId = json['appId'];
    appName = json['appName'];
    server = json['server'];
    serverLogin = json['serverLogin'];
    versionName = json['versionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['langDefault'] = this.langDefault;
    data['releaseDate'] = this.releaseDate;
    data['displayPrint'] = this.displayPrint;
    data['appId'] = this.appId;
    data['appName'] = this.appName;
    data['server'] = this.server;
    data['serverLogin'] = this.serverLogin;
    data['versionName'] = this.versionName;
    return data;
  }
}
