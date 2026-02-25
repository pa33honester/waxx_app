import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/container_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/list_title.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesWidget extends StatelessWidget {
  const PreferencesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ListingController>(
        builder: (controller) {
          final locationParts = [
            if (controller.countryController.text.isNotEmpty) controller.countryController.text,
            if (controller.stateController.text.isNotEmpty) controller.stateController.text,
            if (controller.cityController.text.isNotEmpty) controller.cityController.text,
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              ListTitle(
                title: St.preferences.tr,
                onTap: () {
                  Get.toNamed("/Preferences")?.then(
                    (value) => controller.update(),
                  );
                },
                showCheckIcon: controller.hasPreferences,
              ),
              22.height,
              GestureDetector(
                onTap: () {
                  Get.toNamed("/Preferences")?.then(
                    (value) => controller.update(),
                  );
                },
                child: controller.hasPreferences ? _buildPreferencesContent(controller, locationParts) : _buildEmptyState(controller),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPreferencesContent(ListingController controller, List<String> locationParts) {
    return ContainerDataWidget(
      tap: () {
        Get.toNamed("/Preferences")?.then(
          (value) => controller.update(),
        );
      },
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  St.handlingTime.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  style: AppFontStyle.styleW600(AppColors.white, 12),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  controller.selectedBusinessDays ?? '-',
                  style: AppFontStyle.styleW600(AppColors.white, 13),
                ),
              ),
            ],
          ),
          if (locationParts.isNotEmpty) ...{
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    St.itemLocation.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ":",
                    style: AppFontStyle.styleW600(AppColors.white, 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    locationParts.join(', '),
                    style: AppFontStyle.styleW600(AppColors.white, 13),
                  ),
                )
              ],
            ),
          },
          if (controller.isImmediatePaymentEnabled) ...{
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    St.requireImmediatePayment.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ":",
                    style: AppFontStyle.styleW600(AppColors.white, 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    St.yes.tr,
                    style: AppFontStyle.styleW600(AppColors.white, 13),
                  ),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget _buildEmptyState(ListingController controller) {
    return ContainerWidget(
      onTap: () {
        Get.toNamed("/Preferences")?.then(
          (value) => controller.update(),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info,
            color: AppColors.unselected,
            size: 18,
          ),
          10.width,
          Expanded(
            child: Text(
              St.pleaseProvideAPreferencesForYourItem.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 10),
            ),
          ),
        ],
      ),
    );
  }
}
