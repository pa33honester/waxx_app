// import 'dart:developer';
// import 'package:era_shop/custom/custom_color_bg_widget.dart';
// import 'package:era_shop/custom/main_button_widget.dart';
// import 'package:era_shop/custom/simple_app_bar_widget.dart';
// import 'package:era_shop/localization/locale_constant.dart';
// import 'package:era_shop/localization/localizations_delegate.dart';
// import 'package:era_shop/utils/Strings/strings.dart';
// import 'package:era_shop/utils/Theme/theme_service.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:era_shop/utils/font_style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class Language extends StatefulWidget {
//   const Language({Key? key}) : super(key: key);
//
//   @override
//   State<Language> createState() => _LanguageState();
// }
//
// class _LanguageState extends State<Language> {
//   LanguageController languageController = Get.put(LanguageController());
//   int selectedLanguageIndex = -1;
//
//   List<String> suggestedLanguages = ['English (UK)', 'English', 'Bahasa Indonesia'];
//   List<String> otherLanguages = ['Chineses', 'Croatian', 'Czech', 'Danish', 'Filipino', 'Finland'];
//   @override
//   Widget build(BuildContext context) {
//     return CustomColorBgWidget(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: AppColors.transparent,
//             surfaceTintColor: AppColors.transparent,
//             flexibleSpace: SimpleAppBarWidget(title: St.language.tr),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: languages.length,
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               itemBuilder: (context, index) {
//                 return buildLanguageTile(languages[index].language, index, languages[index].languageCode);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildLanguageTile(String language, int index, String languageCode) {
//     return GetBuilder<LanguageController>(
//       id: "idLanguage",
//       builder: (logic) {
//         return MainButtonWidget(
//           height: 55,
//           width: Get.width,
//           borderRadius: 12,
//           margin: const EdgeInsets.only(bottom: 10),
//           color: AppColors.tabBackground,
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           callback: () async {
//             Get.dialog(Center(child: CircularProgressIndicator(color: AppColors.primary)), barrierDismissible: false);
//             await logic.onLanguageSave(languages[index], index);
//             Get.back();
//           },
//           child: Row(
//             children: [
//               Text(
//                 language,
//                 style: AppFontStyle.styleW700(AppColors.white, 15),
//               ),
//               const Spacer(),
//               Visibility(
//                 visible: logic.checkedValue == index,
//                 child: Container(
//                   height: 24,
//                   width: 24,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColors.primaryPink,
//                   ),
//                   child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class LanguageController extends GetxController {
//   int checkedValue = getStorage.read<int>('checkedValue') ?? 3;
//
//   LanguageModel? languagesChosenValue;
//
//   String? prefLanguageCode;
//   String? prefCountryCode;
//
//   @override
//   void onInit() {
//     getLanguageData();
//     log("prefLanguageCode:::$prefLanguageCode");
//     log("prefCountryCode:::$prefCountryCode");
//     super.onInit();
//   }
//
//   getLanguageData() {
//     prefLanguageCode = getStorage.read(LocalizationConstant.selectedLanguage) ?? LocalizationConstant.languageEn;
//     prefCountryCode = getStorage.read(LocalizationConstant.selectedCountryCode) ?? LocalizationConstant.countryCodeEn;
//     log("prefLanguageCode:::$prefLanguageCode");
//     log("prefCountryCode:::$prefCountryCode");
//     languagesChosenValue = languages.where((element) => (element.languageCode == prefLanguageCode && element.countryCode == prefCountryCode)).toList()[0];
//     update(["idLanguage"]);
//   }
//
//   Future<void> onLanguageSave(LanguageModel value, int index) async {
//     languagesChosenValue = value;
//
//     checkedValue = index;
//
//     getStorage.write('checkedValue', checkedValue);
//
//     getStorage.write(LocalizationConstant.selectedLanguage, languagesChosenValue!.languageCode);
//     getStorage.write(LocalizationConstant.selectedCountryCode, languagesChosenValue!.countryCode);
//
//     await Future.delayed(
//       const Duration(milliseconds: 1000),
//       () {
//         Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
//         Get.back();
//       },
//     );
//   }
//
//   onChangeLanguage(LanguageModel value, int index) {
//     languagesChosenValue = value;
//
//     checkedValue = index;
//
//     getStorage.write('checkedValue', checkedValue);
//
//     update(["idLanguage"]);
//   }
// }

// onLanguageSave(String? languageCode) {
//   languagesChosenValue!.languageCode ==
//       getStorage.write(LocalizationConstant.selectedLanguage, languagesChosenValue!.languageCode);
//   getStorage.write(LocalizationConstant.selectedCountryCode, languagesChosenValue!.countryCode);
//   Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
//   Future.delayed(
//     Duration(milliseconds: 1000),
//     () {
//       Get.back();
//     },
//   );
//   Get.back();`
// }

/*
                     const SizedBox(
                      height: 15,
                    ),Container(
                      height: 218,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                        border:
          Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha:0.30) : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Text(
                "Suggested Languages",
                style: TextStyle(
                    color: isDark.value ? AppColors.white : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestedLanguages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    buildLanguageTile(suggestedLanguages[index], index, AppColors.primaryPink),
                    Divider(
                      height: 3,
                      color: AppColors.darkGrey.withValues(alpha:0.40),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
                        ),
                      ),
                    ),*/
