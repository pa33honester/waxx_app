import 'package:waxxapp/Controller/GetxController/user/faq_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpAndSupportView extends StatefulWidget {
  const HelpAndSupportView({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportView> createState() => _HelpAndSupportViewState();
}

class _HelpAndSupportViewState extends State<HelpAndSupportView> {
  bool isExpanded = false;
  FAQController faqController = Get.put(FAQController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      faqController.getFaqData();
    });
    super.initState();
  }

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
            flexibleSpace: SimpleAppBarWidget(title: St.helpAndSupport.tr),
          ),
        ),
        body: Obx(
          () => faqController.isLoading.value
              ? Center(child: CircularProgressIndicator(color: AppColors.white))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: faqController.faqs!.faQ!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ExpansionTile(
                              childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              collapsedIconColor: AppColors.white,
                              iconColor: AppColors.white,
                              title: Text("${faqController.faqs!.faQ![index].question}", style: AppFontStyle.styleW700(AppColors.white, 16)),
                              children: [
                                Text(
                                  "${faqController.faqs!.faQ![index].answer}",
                                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                ),
                              ],
                            ),
                            Divider(color: AppColors.unselected.withValues(alpha: 0.3)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
