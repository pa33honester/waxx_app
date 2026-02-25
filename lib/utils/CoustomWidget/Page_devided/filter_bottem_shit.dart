import 'dart:developer';

import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_circular.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/GetxController/user/get_all_category_controller.dart';
import '../../../Controller/GetxController/user/get_filterwise_product_controller.dart';
import '../../show_toast.dart';

class FilterBottomShirt extends StatefulWidget {
  const FilterBottomShirt({super.key});

  @override
  State<FilterBottomShirt> createState() => _FilterBottomShirtState();
}

class _FilterBottomShirtState extends State<FilterBottomShirt> {
  RangeValues priseRange = const RangeValues(50.0, 500.0);
  bool isSubCategorySelected = false;
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  GetFilterWiseProductController getFilterWiseProductController = Get.put(GetFilterWiseProductController());

  List<String> selectedCategories = [];

  void handleCategorySelection(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSubCategorySelected = false;
    getAllCategoryController.nameAndId.isEmpty ? getAllCategoryController.getCategory() : null;
  }

  RxString isSelectedCategory = "".obs;

  RxString selectedCategory = RxString('');

  void onSelectedCategory(String categoryName) {
    selectedCategory.value = categoryName;
  }

  @override
  void dispose() {
    getAllCategoryController.nameAndId.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("isSubCategorySelected :: $isSubCategorySelected");
    return StatefulBuilder(builder: (context, setState1) {
      return Container(
        height: Get.height / 1.5,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Obx(
          () => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        20.height,
                        Center(
                          child: Container(
                            height: 3,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        10.height,
                        Row(
                          children: [
                            Text(
                              St.searchFilter.tr,
                              style: AppFontStyle.styleW900(AppColors.white, 18),
                            ),
                            const Spacer(),
                            CircleButtonWidget(
                              size: 30,
                              color: AppColors.transparent,
                              callback: Get.back,
                              child: Center(child: Image.asset(AppAsset.icClose, width: 15)),
                            ),
                          ],
                        ),
                        10.height,
                        Divider(color: AppColors.unselected.withValues(alpha: 0.2)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.height,
                                Text(
                                  St.priseRange.tr,
                                  style: AppFontStyle.styleW700(AppColors.white, 16),
                                ),
                                5.height,
                                RangeSlider(
                                  activeColor: AppColors.primaryPink,
                                  inactiveColor: Colors.grey.shade700.withValues(alpha: 0.40),
                                  values: priseRange,
                                  min: 1.0,
                                  max: 1000.0,
                                  onChanged: (values) {
                                    setState1(() {
                                      getFilterWiseProductController.minPrice = priseRange.start.toInt();
                                      getFilterWiseProductController.maxPrice = priseRange.end.toInt();
                                      log("Start range :: ${priseRange.start.toInt()}");
                                      log("End range :: ${priseRange.end.toInt()}");
                                      priseRange = values;
                                    });
                                  },
                                  labels: RangeLabels(
                                    priseRange.start.toString(),
                                    priseRange.end.toString(),
                                  ),
                                ),
                                10.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "$currencySymbol ${priseRange.start.toStringAsFixed(0)}",
                                        style: AppFontStyle.styleW700(AppColors.black, 14),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "$currencySymbol ${priseRange.end.toStringAsFixed(0)}",
                                        style: AppFontStyle.styleW700(AppColors.black, 14),
                                      ),
                                    ),
                                  ],
                                ),
                                15.height,
                                Text(
                                  St.category.tr,
                                  style: AppFontStyle.styleW700(AppColors.white, 16),
                                ),
                                15.height,
                                getAllCategoryController.isLoading.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : GetBuilder<GetAllCategoryController>(
                                        builder: (GetAllCategoryController getAllCategoryController) => Wrap(
                                          spacing: 8,
                                          children: getAllCategoryController.categoryList.map(
                                            (category) {
                                              return Obx(
                                                () {
                                                  final selectedCategoryName = selectedCategory.value;
                                                  return FilterChip(
                                                    padding: const EdgeInsets.all(10.5),
                                                    showCheckmark: false,
                                                    color: WidgetStatePropertyAll((category.name == selectedCategoryName) ? AppColors.primary : AppColors.tabBackground),
                                                    backgroundColor: AppColors.transparent,
                                                    shadowColor: Colors.transparent,
                                                    label: Text(
                                                      category.name.toString().capitalizeFirst.toString(),
                                                      style: AppFontStyle.styleW700(category.name == selectedCategoryName ? AppColors.black : AppColors.unselected, 13),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      // side: BorderSide(width: 1, color: (category.name == selectedCategoryName) ? AppColors.primary : AppColors.tabBackground),
                                                    ),
                                                    side: BorderSide.none,
                                                    selected: selectedCategories.contains("$category"),
                                                    onSelected: (isSelected) {
                                                      isSubCategorySelected = true;
                                                      getFilterWiseProductController.category = category.id ?? "";
                                                      onSelectedCategory(category.name.toString());
                                                      handleCategorySelection(category.toString());
                                                    },
                                                    selectedColor: AppColors.transparent,
                                                  );
                                                },
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                Visibility(
                                  visible: isSubCategorySelected == true,
                                  child: Column(
                                    children: [
                                      15.height,
                                      Text(
                                        St.subCategory.tr,
                                        style: AppFontStyle.styleW700(AppColors.white, 16),
                                      ),
                                      15.height,
                                    ],
                                  ),
                                ),
                                isSubCategorySelected == true
                                    ? Obx(() {
                                        final selectedCategoryName = selectedCategory.value;
                                        final selectedCategoryData = getAllCategoryController.categoryList.firstWhere((category) => category.name == selectedCategoryName);
                                        return Wrap(
                                          spacing: 8,
                                          children: selectedCategoryData.subCategory!.map((subcategory) {
                                            return FilterChip(
                                              padding: const EdgeInsets.all(10),
                                              showCheckmark: false,
                                              backgroundColor: AppColors.transparent,
                                              color: WidgetStatePropertyAll((subcategory.name == isSelectedCategory.value) ? AppColors.primary : AppColors.tabBackground),
                                              label: Text(
                                                subcategory.name.toString().capitalizeFirst.toString(),
                                                style: AppFontStyle.styleW700((subcategory.name == isSelectedCategory.value) ? AppColors.black : AppColors.unselected, 13),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                // side: BorderSide(color: (subcategory.name == isSelectedCategory.value) ? AppColors.primary : AppColors.tabBackground, width: 1.0),
                                              ),
                                              side: BorderSide.none,
                                              selected: selectedCategories.contains("$subcategory"),
                                              onSelected: (isSelected) {
                                                log("Sub category name :: ${subcategory.name}");
                                                log("Sub category idd :: ${subcategory.id}");
                                                getFilterWiseProductController.subCategory = subcategory.id!;
                                                isSelectedCategory.value = subcategory.name!;
                                                handleCategorySelection(subcategory.toString());
                                              },
                                              selectedColor: AppColors.transparent,
                                            );
                                          }).toList(),
                                        );
                                      })
                                    : const SizedBox.shrink(),
                                15.height,

                                // Padding(
                                //   padding: const EdgeInsets.only(top: 15),
                                //   child: PrimaryPinkButton(onTaped: () {}, text: St.applyFilter.tr),
                                // ),
                                // GestureDetector(
                                //   onTap: () => Get.back(),
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(vertical: 20),
                                //     child: Center(
                                //       child: Text(
                                //         St.clearAll.tr,
                                //         style: GoogleFonts.plusJakartaSans(color: AppColors.primaryRed, fontSize: 16, fontWeight: FontWeight.w600),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        10.height,
                        Row(
                          children: [
                            Expanded(
                              child: MainButtonWidget(
                                height: 50,
                                width: Get.width,
                                color: AppColors.tabBackground,
                                child: Text(
                                  St.clearAll.tr,
                                  style: AppFontStyle.styleW700(AppColors.unselected, 15),
                                ),
                                callback: () => Get.back(),
                              ),
                            ),
                            15.width,
                            Expanded(
                              child: MainButtonWidget(
                                height: 50,
                                width: Get.width,
                                color: AppColors.primary,
                                child: Text(
                                  St.applyFilter.tr,
                                  style: AppFontStyle.styleW700(AppColors.black, 15),
                                ),
                                callback: () {
                                  setState1(() {
                                    log("Category 111:: ${getFilterWiseProductController.category}");
                                    log("Sub Category 111:: ${getFilterWiseProductController.subCategory}");
                                    if (getFilterWiseProductController.category.isNotEmpty && getFilterWiseProductController.subCategory.isNotEmpty) {
                                      getFilterWiseProductController.getFilteredProducts();
                                    } else {
                                      displayToast(message: "Select category & subcategory");
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        10.height,
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 18),
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         Get.back();
                    //       },
                    //       child: Container(
                    //         height: 45,
                    //         width: 45,
                    //         decoration: BoxDecoration(
                    //           color: isDark.value ? const Color(0xff282836) : const Color(0xffeceded),
                    //           shape: BoxShape.circle,
                    //         ),
                    //         child: const Icon(
                    //           Icons.close,
                    //           size: 19,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              getFilterWiseProductController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox()
            ],
          ),
        ),
      );
    });
  }
}
