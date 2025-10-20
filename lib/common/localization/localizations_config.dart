import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'app_localizations.dart';

class LocalizationsConfig {
  static Locale getCurrentLocale() {
    String lang = Globals.prefs
        .getString(SharedPrefsKey.language, value: LangKey.langDefault);
    Globals.localeType = lang == LangKey.langVi ? LocaleType.vi : LocaleType.en;
    return Locale(lang);
  }

  static const List<Locale> supportedLocales = [
    Locale(LangKey.langVi, 'VN'),
    Locale(LangKey.langEn, 'EN'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate
  ];

  static Locale localeResolutionCallback(
      Locale? locale, List<Locale> supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale!.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
