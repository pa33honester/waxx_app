import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    final String categoryId = args?['categoryId'] ?? '';
    final String categoryName = args?['categoryName'] ?? '';
    final controller = Get.find<ListingController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterSubCategories('', categoryId ?? '');
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GetBuilder<ListingController>(
            builder: (controller) {
              return ListingAppBarWidget(
                title: categoryName,
                showCheckIcon: true,
                isCheckEnabled: controller.hasCategory,
                onCheckTap: () {
                  Get.back();
                },
              );
            },
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<ListingController>(
          builder: (controller) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  cursorColor: AppColors.unselected,
                  controller: controller.searchSucCatController,
                  textInputAction: TextInputAction.search,
                  style: AppFontStyle.styleW500(AppColors.white, 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.tabBackground,
                    hintText: St.searchForASubCategory.tr,
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
                    controller.filterSubCategories(value, categoryId ?? '');
                  },
                ),
                40.height,
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.filteredSubCategories.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedSubCategoryId == controller.filteredSubCategories[index].id;
                      return GestureDetector(
                        onTap: () {
                          final selectedSubCategory = controller.filteredSubCategories[index];

                          controller.selectedCategoryName = categoryName;
                          controller.selectedCategoryId = categoryId;
                          controller.selectedSubCategoryName = selectedSubCategory.name;
                          controller.selectedSubCategoryId = selectedSubCategory.id;
                          controller.clearAttributeValues();

                          Get.close(2);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                controller.filteredSubCategories[index].name ?? "",
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
