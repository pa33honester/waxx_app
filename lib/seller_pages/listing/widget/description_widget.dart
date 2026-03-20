import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/container_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/list_title.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

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
                title: St.description.tr,
                onTap: () {
                  Get.toNamed("/Description")?.then(
                    (value) => controller.update(),
                  );
                },
                showCheckIcon: controller.hasDescription,
              ),
              22.height,
              controller.descriptionController.text.isNotEmpty
                  ? ContainerDataWidget(
                      tap: () {
                        Get.toNamed("/Description")?.then(
                          (value) => controller.update(),
                        );
                      },
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Text(
                        controller.descriptionController.text,
                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                      ),
                    )
                  : ContainerWidget(
                      onTap: () {
                        Get.toNamed("/Description")?.then(
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
                          Text(
                            St.pleaseProvideADescriptiveTitleForYourItem.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          ).paddingOnly(right: 30),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
