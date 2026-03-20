import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GetBuilder<ListingController>(
            builder: (controller) {
              return ListingAppBarWidget(
                title: St.category.tr,
                showCheckIcon: true,
                isCheckEnabled: controller.hasCategory,
                onCheckTap: () {
                  Get.back();
                },
              );
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<ListingController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  cursorColor: AppColors.unselected,
                  controller: controller.searchCategoryController,
                  textInputAction: TextInputAction.search,
                  style: AppFontStyle.styleW500(AppColors.white, 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.tabBackground,
                    hintText: St.searchForACategory.tr,
                    hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                    contentPadding: const EdgeInsets.only(bottom: 5),
                    prefixIcon: Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected.withValues(alpha: 0.5)).paddingAll(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    controller.filterCategories(value);
                  },
                ),
                40.height,
                Text(
                  St.allCategories.tr,
                  style: AppFontStyle.styleW900(AppColors.white, 18),
                ),
                40.height,
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredCategories.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedCategoryId == controller.filteredCategories[index].id;
                      return GestureDetector(
                        onTap: () {
                          final selectedCategory = controller.filteredCategories[index];

                          Get.toNamed('/SubCategory', arguments: {
                            'categoryId': selectedCategory.id,
                            'categoryName': selectedCategory.name,
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${controller.filteredCategories[index].name}',
                                style: AppFontStyle.styleW500(AppColors.white, 14),
                              ).paddingOnly(bottom: 30),
                            ),
                            if (isSelected) ...[
                              10.width,
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.check,
                                  color: AppColors.black,
                                  size: 18,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
