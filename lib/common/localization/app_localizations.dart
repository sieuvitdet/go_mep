import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    var jsonString = await rootBundle
        .loadString('./assets/json/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  static String text(String key) {
    return _localizedStrings[key] ?? "";
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// ignore: lines_longer_than_80_chars
// In this case, the localized strings will be gotten in an AppLocalizations object
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return [LangKey.langVi, LangKey.langEn].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    var localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
