import 'package:waxxapp/localization/language/arabic_language.dart';
import 'package:waxxapp/localization/language/bangali_language.dart';
import 'package:waxxapp/localization/language/chinese_language.dart';
import 'package:waxxapp/localization/language/english_language.dart';
import 'package:waxxapp/localization/language/french_language.dart';
import 'package:waxxapp/localization/language/german_language.dart';
import 'package:waxxapp/localization/language/hindi_language.dart';
import 'package:waxxapp/localization/language/indonesian_language.dart';
import 'package:waxxapp/localization/language/italian_language.dart';
import 'package:waxxapp/localization/language/korean_language.dart';
import 'package:waxxapp/localization/language/portuguese_language.dart';
import 'package:waxxapp/localization/language/russian_language.dart';
import 'package:waxxapp/localization/language/spanish_language.dart';
import 'package:waxxapp/localization/language/swahili_language.dart';
import 'package:waxxapp/localization/language/tamil_language.dart';
import 'package:waxxapp/localization/language/telugu_language.dart';
import 'package:waxxapp/localization/language/turkish_language.dart';
import 'package:waxxapp/localization/language/urdu_language.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:get/get.dart';

class AppLanguages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar_DZ": ardz,
        "bn_In": bnIN,
        "zh_CN": zhCN,
        "en_US": enUS,
        "fr_Fr": frCH,
        "de_De": deat,
        "hi_IN": hiIN,
        "it_In": itIT,
        "id_ID": idID,
        "ko_KR": koKR,
        "pt_PT": ptPT,
        "ru_RU": ruRU,
        "es_ES": esES,
        "sw_KE": swKE,
        "tr_TR": trTR,
        "te_IN": teIN,
        "ta_IN": taIN,
        "ur_PK": urPK,
      };
}

final List<LanguageModel> languages = [
  LanguageModel("dz", "Arabic (العربية)", 'ar', 'DZ', AppAsset.pakistan),
  LanguageModel("🇮🇳", "Bengali (বাংলা)", 'bn', 'IN', AppAsset.india),
  LanguageModel("🇨🇳", "Chinese Simplified (中国人)", 'zh', 'CN', AppAsset.chinese),
  LanguageModel("🇺🇸", "English (English)", 'en', 'US', AppAsset.english),
  LanguageModel("🇫🇷", "French (français)", 'fr', 'FR', AppAsset.french),
  LanguageModel("🇩🇪", "German (Deutsche)", 'de', 'DE', AppAsset.german),
  LanguageModel("🇮🇳", "Hindi (हिंदी)", 'hi', 'IN', AppAsset.india),
  LanguageModel("🇮🇹", "Italian (italiana)", 'it', 'IT', AppAsset.italian),
  LanguageModel("🇮🇩", "Indonesian (bahasa indo)", 'id', 'ID', AppAsset.indonesian),
  LanguageModel("🇰🇵", "Korean (한국인)", 'ko', 'KR', AppAsset.korean),
  LanguageModel("🇵🇹", "Portuguese (português)", 'pt', 'PT', AppAsset.portuguese),
  LanguageModel("🇷🇺", "Russian (русский)", 'ru', 'RU', AppAsset.russian),
  LanguageModel("🇪🇸", "Spanish (Español)", 'es', 'ES', AppAsset.spanish),
  LanguageModel("🇰🇪", "Swahili (Kiswahili)", 'sw', 'KE', AppAsset.swahili),
  LanguageModel("🇹🇷", "Turkish (Türk)", 'tr', 'TR', AppAsset.turkish),
  LanguageModel("🇮🇳", "Telugu (తెలుగు)", 'te', 'IN', AppAsset.india),
  LanguageModel("🇮🇳", "Tamil (தமிழ்)", 'ta', 'IN', AppAsset.india),
  LanguageModel("🇵🇰", "(اردو) Urdu", 'ur', 'PK', AppAsset.pakistan),
];

class LanguageModel {
  LanguageModel(
    this.symbol,
    this.language,
    this.languageCode,
    this.countryCode,
    this.countryImage,
  );

  String language;
  String symbol;
  String countryCode;
  String languageCode;
  String countryImage;
}
