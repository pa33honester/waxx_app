import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/container_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/list_title.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ListingController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              ListTitle(
                title: St.title.tr,
                onTap: () {
                  Get.toNamed("/TitleEdit")?.then(
                    (value) => controller.update(),
                  );
                },
                showCheckIcon: controller.hasTitle,
              ),
              22.height,
              controller.titleController.text.isNotEmpty
                  ? ContainerDataWidget(
                      tap: () {
                        Get.toNamed("/TitleEdit")?.then(
                          (value) => controller.update(),
                        );
                      },
                      child: Text(
                        controller.titleController.text,
                        style: AppFontStyle.styleW800(AppColors.white, 18),
                      ),
                    )
                  : ContainerWidget(
                      onTap: () {
                        Get.toNamed("/TitleEdit")?.then(
                          (value) => controller.update(),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppColors.unselected,
                            size: 18,
                          ),
                          10.width,
                          Text(
                            St.pleaseProvideATitleForYourItem.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          )
                        ],
                      ),
                    ),
              if (controller.subTitleController.text.isNotEmpty) ...{
                22.height,
                Text(
                  St.subTitle.tr,
                  style: AppFontStyle.styleW600(AppColors.unselected, 14),
                ),
                6.height,
                Text(
                  controller.subTitleController.text,
                  style: AppFontStyle.styleW600(AppColors.white, 18),
                ),
              },
            ],
          );
        },
      ),
    );
  }
}
