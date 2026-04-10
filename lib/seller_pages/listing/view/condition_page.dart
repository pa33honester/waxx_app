import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionPage extends StatelessWidget {
  ConditionPage({super.key});

  final controller = Get.put(ListingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.grayLight.withValues(alpha: 0.4),
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppAsset.icBack, width: 15),
                      ),
                    ),
                    16.width,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              St.selectCondition.tr,
              style: AppFontStyle.styleW900(AppColors.primary, 20),
            ),
            6.height,
            Text(
              'Disclose all flaws to prevent returns and earn better feedback. Examples of flaws',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.unselected,
              ),
            ),
            32.height,
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<ListingController>(
                    id: AppConstant.idCondition,
                    builder: (logic) {
                      return ListView.builder(
                        itemCount: logic.conditions.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final condition = logic.conditions[index];
                          return _buildConditionCard(
                            title: condition['title']!,
                            description: condition['description']!,
                            isSelected: logic.selectedCondition == condition['title'],
                            onTap: () => controller.selectCondition(condition['title']!),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<ListingController>(
          id: AppConstant.idCondition,
          builder: (logic) {
            return MainButtonWidget(
              height: 55,
              width: Get.width,
              margin: const EdgeInsets.all(15),
              color: logic.isConditionSelected ? AppColors.primary : AppColors.unselected,
              child: Text(
                St.continueText.tr.toUpperCase(),
                style: AppFontStyle.styleW700(logic.isConditionSelected ? AppColors.black : AppColors.white, 16),
              ),
              callback: () {
                Get.toNamed("/ListingSummary");
              },
            );
          }),
    );
  }

  Widget _buildConditionCard({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFontStyle.styleW700(isSelected ? AppColors.primary : AppColors.white, 16),
              ),
              8.height,
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.unselected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
