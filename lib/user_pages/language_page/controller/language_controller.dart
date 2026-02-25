import 'dart:developer';
import 'package:era_shop/localization/locale_constant.dart';
import 'package:era_shop/localization/localizations_delegate.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  int checkedValue = getStorage.read<int>('checkedValue') ?? 3;

  LanguageModel? languagesChosenValue;

  String? prefLanguageCode;
  String? prefCountryCode;

  @override
  void onInit() {
    getLanguageData();
    log("prefLanguageCode:::$prefLanguageCode");
    log("prefCountryCode:::$prefCountryCode");
    super.onInit();
  }

  getLanguageData() {
    prefLanguageCode = getStorage.read(LocalizationConstant.selectedLanguage) ?? LocalizationConstant.languageEn;
    prefCountryCode = getStorage.read(LocalizationConstant.selectedCountryCode) ?? LocalizationConstant.countryCodeEn;
    log("prefLanguageCode:::$prefLanguageCode");
    log("prefCountryCode:::$prefCountryCode");
    languagesChosenValue = languages.where((element) => (element.languageCode == prefLanguageCode && element.countryCode == prefCountryCode)).toList()[0];
    update(["idLanguage"]);
  }

  Future<void> onLanguageSave(LanguageModel value, int index) async {
    languagesChosenValue = value;

    checkedValue = index;

    getStorage.write('checkedValue', checkedValue);

    getStorage.write(LocalizationConstant.selectedLanguage, languagesChosenValue!.languageCode);
    getStorage.write(LocalizationConstant.selectedCountryCode, languagesChosenValue!.countryCode);

    await Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
        Get.back();
      },
    );
  }

  onChangeLanguage(LanguageModel value, int index) {
    languagesChosenValue = value;

    checkedValue = index;

    getStorage.write('checkedValue', checkedValue);

    update(["idLanguage"]);
  }
}
