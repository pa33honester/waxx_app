import 'dart:developer';
import 'dart:ui';

import 'package:era_shop/utils/Theme/theme_service.dart';

Future<Locale> getLocale() async {
  String languageCode = getStorage.read(LocalizationConstant.selectedLanguage) ?? LocalizationConstant.languageEn;
  String countryCode = getStorage.read(LocalizationConstant.selectedCountryCode) ?? LocalizationConstant.countryCodeEn;
  log("getLocale Updated $languageCode   $countryCode");
  return _locale(languageCode, countryCode);
}

Locale _locale(String languageCode, String countryCode) {
  return languageCode.isNotEmpty ? Locale(languageCode, countryCode) : const Locale(LocalizationConstant.languageEn, LocalizationConstant.countryCodeEn);
}

class LocalizationConstant {
  static const languageEn = "en";
  static const countryCodeEn = "US";

  /// Preference
  static const String selectedLanguage = "LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";
}
