import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/container_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/list_title.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

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
                title: St.category.tr,
                onTap: () {
                  Get.toNamed("/Category")?.then(
                    (value) => controller.update(),
                  );
                },
                showCheckIcon: controller.hasCategory,
              ),
              22.height,
              controller.hasCategory
                  ? ContainerDataWidget(
                      tap: () {
                        Get.toNamed("/Category")?.then(
                          (value) => controller.update(),
                        );
                      },
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Row(
                        children: [
                          Text(
                            (controller.selectedCategoryName?.isNotEmpty ?? false)
                                ? controller.selectedCategoryName!
                                : (controller.selectedSubCategoryName?.isNotEmpty ?? false)
                                    ? "-"
                                    : "-",
                            style: AppFontStyle.styleW500(AppColors.white, 14),
                          ),
                          if ((controller.selectedCategoryName?.isNotEmpty ?? false) && (controller.selectedSubCategoryName?.isNotEmpty ?? false)) ...[
                            Text(
                              " > ",
                              style: AppFontStyle.styleW500(AppColors.white, 14),
                            ),
                            Text(
                              controller.selectedSubCategoryName!,
                              style: AppFontStyle.styleW500(AppColors.white, 14),
                            ),
                          ] else if (controller.selectedSubCategoryName?.isNotEmpty ?? false) ...[
                            Text(
                              controller.selectedSubCategoryName!,
                              style: AppFontStyle.styleW500(AppColors.white, 14),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ContainerWidget(
                      onTap: () {
                        Get.toNamed("/Category")?.then(
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
                            St.pleaseProvideACategoryForYourItem.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          )
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
