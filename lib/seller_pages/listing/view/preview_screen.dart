import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                    Expanded(
                      child: Text(
                        St.preview.tr,
                        style: AppFontStyle.styleW900(AppColors.white, 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // onClickShare();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppAsset.icShare,
                      // width: 18,
                      height: 18,
                      color: AppColors.unselected,
                    ),
                  ),
                ),
                16.width,
              ],
            ),
          ],
        ),
      ),
      body: GetBuilder<ListingController>(
        builder: (controller) {
          final locationParts = [
            if (controller.countryController.text.isNotEmpty) controller.countryController.text,
            if (controller.stateController.text.isNotEmpty) controller.stateController.text,
            if (controller.cityController.text.isNotEmpty) controller.cityController.text,
          ];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    St.previewYourListing.tr,
                    style: AppFontStyle.styleW700(AppColors.white, 18),
                  ),
                  4.height,
                  Text(
                    St.thisIsHowYourListingWillLookWhen.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 14),
                  ),
                  15.height,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: Get.width,
                    child: controller.imageFileList.isEmpty
                        ? Image.asset(
                            AppAsset.categoryPlaceholder,
                            height: 120,
                          ).paddingSymmetric(horizontal: 50, vertical: 100)
                        : Column(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                height: 420,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    PageView.builder(
                                      controller: controller.productController,
                                      itemCount: controller.imageFileList.length,
                                      onPageChanged: (value) {
                                        controller.onSelectImage(value);
                                      },
                                      itemBuilder: (context, index) {
                                        return Image.file(controller.imageFileList[index], height: 100, fit: BoxFit.cover);
                                      },
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      child: SmoothPageIndicator(
                                        effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primary),
                                        controller: controller.productController,
                                        count: controller.imageFileList.length.toInt(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    controller.titleController.text.isNotEmpty ? controller.titleController.text : "",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppFontStyle.styleW700(AppColors.white, 20),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    height: 36,
                                                    width: 36,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white.withValues(alpha: 0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.asset(
                                                      AppAsset.icHeart,
                                                      width: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Obx(() {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        controller.descriptionController.text.isNotEmpty
                                                            ? Expanded(
                                                                child: Text(
                                                                  controller.descriptionController.text,
                                                                  maxLines: controller.isDescriptionExpanded.value ? null : 2,
                                                                  overflow: controller.isDescriptionExpanded.value ? TextOverflow.clip : TextOverflow.ellipsis,
                                                                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                                                ),
                                                              )
                                                            : Offstage(),
                                                        GestureDetector(
                                                          onTap: () => controller.toggleDescription(),
                                                          child: Text(
                                                            controller.isDescriptionExpanded.value ? St.less.tr : St.more.tr,
                                                            style: TextStyle(
                                                              color: AppColors.primary,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                              5.height,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (locationParts.isNotEmpty) ...{
                                      5.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image(
                                            color: AppColors.unselected,
                                            image: AssetImage(AppImage.location),
                                            height: 15,
                                          ),
                                          8.width,
                                          Text(
                                            locationParts.join(', '),
                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                          ),
                                          10.width,
                                          Image(
                                            color: AppColors.unselected,
                                            image: AssetImage(AppImage.cart),
                                            height: 15,
                                          ),
                                          5.width,
                                          Text(
                                            "${20} ${St.sold.tr}",
                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                          ),
                                          10.width,
                                          Image(
                                            image: AssetImage(AppImage.icStar),
                                            height: 14,
                                          ),
                                          5.width,
                                          Text(
                                            '3.0',
                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                          ),
                                        ],
                                      ),
                                      5.height,
                                    },
                                    _buildPricingContent(controller),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  26.height,
                  _buildAttributesSummary(controller),
                  15.height,
                  Text(
                    St.productDetails.tr,
                    style: AppFontStyle.styleW700(AppColors.white, 16),
                  ),
                  15.height,
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            St.category.tr,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          5.height,
                          Text(
                            St.subCategory.tr,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                        ],
                      ),
                      20.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ":",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          5.height,
                          Text(
                            ":",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                        ],
                      ),
                      25.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (controller.selectedCategoryName?.isNotEmpty ?? false) ? controller.selectedCategoryName ?? '' : "-",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(AppColors.white, 14),
                          ),
                          5.height,
                          Text(
                            controller.selectedSubCategoryName ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(AppColors.primary, 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  15.height,
                  if (controller.descriptionController.text.isNotEmpty)
                    Text(
                      controller.descriptionController.text,
                      style: AppFontStyle.styleW500(AppColors.unselected, 12),
                    ),
                  10.height,
                  Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                  10.height,
                  Text(
                    St.aboutThisSeller.tr,
                    style: AppFontStyle.styleW700(AppColors.primary, 16),
                  ),
                  20.height,
                  Row(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: imageXFile == null
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: editImage,
                                placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
                                errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
                              )
                            : Image.file(File(imageXFile?.path ?? "")),
                      ),
                      16.width,
                      Text(
                        "${editFirstName.capitalizeFirst} $editLastName",
                        style: AppFontStyle.styleW700(AppColors.white, 18),
                      ),
                    ],
                  ),
                  26.height,
                  MainButtonWidget(
                    height: 60,
                    callback: () {
                      // Get.toNamed('/PreviewScreen');
                    },
                    border: Border.all(color: AppColors.primary),
                    color: Colors.transparent,
                    child: Text(
                      St.addToCart.tr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppFontStyle.styleW700(AppColors.primary, 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      /* body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<ListingController>(
            id: AppConstant.idPreviewImage,
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      St.previewYourListing.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 18),
                    ),
                    4.height,
                    Text(
                      St.thisIsHowYourListingWillLookWhen.tr,
                      style: AppFontStyle.styleW500(AppColors.unselected, 14),
                    ),
                    16.height,
                    controller.imageFileList.isNotEmpty
                        ? Column(
                            children: [
                              Container(
                                  height: 300,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.file(controller.imageFileList[controller.selectedImageIndex])),
                              16.height,
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.imageFileList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.onSelectImage(index);
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        margin: EdgeInsets.only(right: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: controller.selectedImageIndex == index ? AppColors.primary : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.file(
                                              controller.imageFileList[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 300,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              AppAsset.categoryPlaceholder,
                              height: 22,
                            ).paddingAll(60),
                          ),
                    30.height,
                    controller.titleController.text.isNotEmpty
                        ? Text(
                            controller.titleController.text.capitalizeFirst ?? '',
                            style: AppFontStyle.styleW800(AppColors.white, 20),
                          )
                        : Text(
                            St.enterYourTitle.tr,
                            style: AppFontStyle.styleW800(AppColors.white, 20),
                          ),
                    20.height,
                    _buildPricingContent(controller),
                    30.height,
                    Text(
                      St.aboutThisItem.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    20.height,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            St.category.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            controller.selectedCategoryName?.isNotEmpty ?? false ? controller.selectedCategoryName ?? '' : "-",
                            style: AppFontStyle.styleW600(AppColors.white, 14),
                          ),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            St.subCategory.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            controller.selectedCategoryName?.isNotEmpty ?? false ? controller.selectedSubCategoryName ?? '' : "-",
                            style: AppFontStyle.styleW600(AppColors.white, 14),
                          ),
                        ),
                      ],
                    ),
                    30.height,
                    Text(
                      St.itemSpecific.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    20.height,
                    _buildAttributesSummary(controller),
                    // 30.height,
                    // Text(
                    //   St.pricing.tr,
                    //   style: AppFontStyle.styleW700(AppColors.white, 16),
                    // ),
                    // 20.height,
                    // _buildPricingContent(controller),
                    30.height,
                    Text(
                      St.itemDescriptionFromTheSeller.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    20.height,
                    Text(
                      controller.descriptionController.text.isNotEmpty ? controller.descriptionController.text : "-",
                      style: AppFontStyle.styleW500(AppColors.unselected, 14),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'See full description',
                    //       style: TextStyle(
                    //           color: AppColors.unselected,
                    //           fontSize: 14,
                    //           decoration: TextDecoration.underline,
                    //           decorationThickness: 2,
                    //           decorationColor: AppColors.unselected),
                    //     ),
                    //     Icon(
                    //       Icons.navigate_next,
                    //       color: AppColors.unselected,
                    //     )
                    //   ],
                    // ),
                    30.height,
                    Text(
                      St.aboutThisSeller.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    20.height,
                    Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: imageXFile == null
                              ? CachedNetworkImage(
                                  imageUrl: editImage,
                                  placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
                                  errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
                                )
                              : Image.file(File(imageXFile?.path ?? "")),
                        ),
                        16.width,
                        Text(
                          'jems_bond',
                          style: AppFontStyle.styleW700(AppColors.white, 16),
                        ),
                        // Container(
                        //   height: 52,
                        //   width: 52,
                        //   clipBehavior: Clip.antiAlias,
                        //   decoration: const BoxDecoration(shape: BoxShape.circle),
                        //   child: sellerImageXFile == null
                        //       ? Image.network(sellerEditImage, fit: BoxFit.cover)
                        //       : Image.file(File(sellerImageXFile?.path ?? "")),
                        // ),
                        // Text(
                        //   editBusinessName,
                        //   style: AppFontStyle.styleW700(AppColors.white, 16),
                        // ),
                        // 3.height,
                        // Text(
                        //   editBusinessTag,
                        //   style: AppFontStyle.styleW500(AppColors.white, 12),
                        // ),
                      ],
                    ),
                    30.height,
                    MainButtonWidget(
                      height: 60,
                      callback: () {
                        // Get.toNamed('/PreviewScreen');
                      },
                      border: Border.all(color: AppColors.primary),
                      color: Colors.transparent,
                      child: Text(
                        St.addToCart.tr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppFontStyle.styleW700(AppColors.primary, 15),
                      ),
                    ),
                    20.height,
                  ],
                ),
              );
            }),
      ),*/
    );
  }

  Map<String, dynamic> _getAttributesData(ListingController controller) {
    final selectedSubCategoryId = controller.selectedSubCategoryId;
    final relevantAttributes = controller.fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    List<Map<String, dynamic>> attributesList = [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        final attributeName = attribute.name ?? '';
        final attributeValue = controller.getAttributeValue(attributeName);

        if (controller.isAttributeValueValid(attributeValue)) {
          attributesList.add({
            'name': attributeName,
            'value': attributeValue,
            'fieldType': attribute.fieldType ?? 1,
          });
        }
      }
    }

    return {
      'attributesList': attributesList,
      'visibleAttributes': attributesList.toList(),
      'remainingCount': attributesList.length > 2 ? attributesList.length - 2 : 0,
    };
  }

  // bool _isAttributeValueValid(dynamic attributeValue) {
  //   if (attributeValue == null) return false;
  //
  //   if (attributeValue is String) {
  //     return attributeValue.trim().isNotEmpty && attributeValue.trim() != 'null';
  //   }
  //
  //   if (attributeValue is List) {
  //     return attributeValue.isNotEmpty && attributeValue.any((item) => item != null && item.toString().trim().isNotEmpty && item.toString().trim() != 'null');
  //   }
  //
  //   return attributeValue.toString().trim().isNotEmpty && attributeValue.toString().trim() != 'null';
  // }

// Updated title row with View All button
  Widget _buildProductDetailsHeader(ListingController controller) {
    final attributesData = _getAttributesData(controller);
    final remainingCount = attributesData['remainingCount'] as int;
    final attributesList = attributesData['attributesList'] as List<Map<String, dynamic>>;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          St.productDetails.tr,
          style: AppFontStyle.styleW700(AppColors.primary, 16),
        ),
        if (remainingCount > 0)
          GestureDetector(
            onTap: () => _showAllAttributesBottomSheet(Get.context!, controller, attributesList),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  St.viewAll.tr,
                  style: AppFontStyle.styleW600(AppColors.white, 12),
                ),
                // 4.width,
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //   decoration: BoxDecoration(
                //     color: AppColors.primary.withValues(alpha: 0.2),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     "+${remainingCount}",
                //     style: AppFontStyle.styleW600(AppColors.primary, 10),
                //   ),
                // ),
                4.width,
                Icon(
                  Icons.keyboard_arrow_right,
                  color: AppColors.white,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }

  _buildAttributesSummary(ListingController controller) {
    final attributesData = _getAttributesData(controller);
    final visibleAttributes = attributesData['visibleAttributes'] as List<Map<String, dynamic>>;

    if (visibleAttributes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.unselected.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            St.noProductDetailsAvailable.tr,
            style: AppFontStyle.styleW500(AppColors.unselected, 14),
          ),
        ),
      );
    }

    return Column(
      children: visibleAttributes
          .map((attr) => _buildAttributeItem(
                attr['name'],
                attr['value'],
              ))
          .toList(),
    );
  }

  Widget _buildAttributeItem(
    String attributeName,
    dynamic attributeValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select ${attributeName.toString()}",
          overflow: TextOverflow.ellipsis,
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            height: Get.width * 0.11,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: attributeValue.length,
              itemBuilder: (context, index) {
                final value = attributeValue[index];
                final isSelected = attributeValue == value;

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width * 0.14,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? AppColors.primaryPink : AppColors.tabBackground,
                    ),
                    child: FittedBox(
                      child: Text(
                        value,
                        style: AppFontStyle.styleW600(AppColors.unselected, 15),
                      ),
                    ),
                  ).paddingOnly(right: 10),
                );
              },
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 8);
  }

  void _showAllAttributesBottomSheet(BuildContext context, ListingController controller, List<Map<String, dynamic>> attributesList) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) => Container(
        height: Get.height * 0.65,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.unselected.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.featured_play_list_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: Text(
                      St.productSpecifications.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Attributes list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: attributesList.map((attr) => _buildBottomSheetAttributeItem(attr['name'], attr['value'])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Individual attribute item for bottom sheet
  Widget _buildBottomSheetAttributeItem(String attributeName, dynamic attributeValue) {
    // String displayValue = '';
    final displayValues = attributeValue is List ? (attributeValue as List).where((e) => e != null).map((e) => e.toString()).join(', ') : attributeValue?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.unselected.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attribute name
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              10.width,
              Expanded(
                child: Text(
                  attributeName,
                  style: AppFontStyle.styleW600(AppColors.unselected, 14),
                ),
              ),
            ],
          ),
          6.height,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildValueContainer(displayValues),
          ),
        ],
      ),
    );
  }

  Widget _buildValueContainer(
    String displayValue,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayValue,
        style: AppFontStyle.styleW600(AppColors.white, 14),
      ),
    );
  }

  /// --- price
  Widget _buildPricingContent(ListingController controller) {
    return _buildBuyItNowContent(controller);
  }

  Widget _buildBuyItNowContent(ListingController controller) {
    bool hasPrice = controller.buyItNowPriceController.text.isNotEmpty;

    if (!hasPrice) {
      return Offstage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   St.buyItNow.tr,
        //   style: AppFontStyle.styleW700(AppColors.primary, 14),
        // ),
        // 10.height,
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\$${controller.minimumOfferAmountController.text.isEmpty ? controller.buyItNowPriceController.text : controller.minimumOfferAmountController.text}",
              style: AppFontStyle.styleW800(
                AppColors.primary,
                20,
              ),
            ),
            if (controller.isOffersAllowed) ...[
              10.width,
              Text(
                "\$${controller.buyItNowPriceController.text}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.unselected,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.unselected,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
