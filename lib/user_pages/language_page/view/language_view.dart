import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/localization/localizations_delegate.dart';
import 'package:waxxapp/user_pages/language_page/controller/language_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final controller = Get.put(LanguageController());
  int selectedLanguageIndex = -1;

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.language.tr),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: languages.length,
              padding: const EdgeInsets.symmetric(vertical: 15),
              itemBuilder: (context, index) {
                return buildLanguageTile(languages[index].language, index, languages[index].languageCode, languages[index].countryImage);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLanguageTile(String language, int index, String languageCode, String image) {
    return GetBuilder<LanguageController>(
      id: "idLanguage",
      builder: (logic) {
        return MainButtonWidget(
          height: 55,
          width: Get.width,
          borderRadius: 12,
          margin: const EdgeInsets.only(bottom: 10),
          color: AppColors.tabBackground,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          callback: () async {
            Get.dialog(Center(child: CircularProgressIndicator(color: AppColors.primary)), barrierDismissible: false);
            await logic.onLanguageSave(languages[index], index);
            Get.back();
          },
          child: Row(
            children: [
              Image.asset(
                image,
                height: 30,
              ),
              16.width,
              Text(
                language,
                style: AppFontStyle.styleW700(AppColors.white, 15),
              ),
              const Spacer(),
              Visibility(
                visible: logic.checkedValue == index,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPink,
                  ),
                  child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
