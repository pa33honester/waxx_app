import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/controller/select_product_for_controller.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/model/fetch_product_model.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSelectedProductsBottomSheet {
  static void show(
    SelectProductsForStreamerController logic,
  ) {
    if (logic.selectedProductsArray.isEmpty) {
      Utils.showToast(St.noProductsSelected.tr);
      return;
    }

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            10.height,
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "${St.selectedProducts.tr} (${logic.selectedProductsArray.length})",
                    textAlign: TextAlign.center,
                    style: AppFontStyle.styleW700(AppColors.white, 18),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppAsset.icClose,
                        height: 16,
                        color: AppColors.unselected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.unselected.withValues(alpha: .5),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logic.selectedProductsArray.length,
                itemBuilder: (context, index) {
                  var selectedProduct = logic.selectedProductsArray[index];
                  var product = selectedProduct['product'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product?.mainImage ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product?.productName ?? " ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFontStyle.styleW700(AppColors.white, 16),
                                        ),
                                        4.height,
                                        Text(
                                          "$currencySymbol ${product?.price ?? 0}",
                                          style: AppFontStyle.styleW700(AppColors.primary, 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  8.width,
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          _showEditProductBottomSheet(
                                            Get.context!,
                                            product!,
                                            selectedProduct,
                                            index,
                                            logic,
                                          );
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.greenBackground,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: AppColors.green,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      8.width,
                                      GestureDetector(
                                        onTap: () {
                                          logic.removeSelectedProduct(index);
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(color: AppColors.redBackground, borderRadius: BorderRadius.circular(8)),
                                          child: Image.asset(
                                            "assets/icons/delete_address.png",
                                            height: 18,
                                          ).paddingAll(6.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (selectedProduct['selectedAttributes'] != null && (selectedProduct['selectedAttributes'] as Map<String, dynamic>).isNotEmpty) ...[
                                8.height,
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: (selectedProduct['selectedAttributes'] as Map<String, dynamic>)
                                      .entries
                                      .map((entry) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: AppColors.unselected.withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                              color: AppColors.unselected.withValues(alpha: 0.1),
                                            ),
                                            child: Text(
                                              "${entry.key}: ${entry.value}",
                                              style: AppFontStyle.styleW500(AppColors.white, 12),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Method to show edit bottom sheet with pre-filled data
  static void _showEditProductBottomSheet(
    BuildContext context,
    InventoryProduct product,
    Map<String, dynamic> selectedProductData,
    int productIndex,
    SelectProductsForStreamerController logic,
  ) {
    // Create a modified version of AddProductDetailsBottomSheet for editing
    _showEditProductDetailsBottomSheet(
      context,
      product,
      selectedProductData,
      productIndex,
      logic,
    );
  }

  static void _showEditProductDetailsBottomSheet(
    BuildContext context,
    InventoryProduct catalogItems,
    Map<String, dynamic> existingData,
    int productIndex,
    SelectProductsForStreamerController logic,
  ) {
    // Pre-fill controllers with existing data
    log("Existing Data: $existingData");
    log("Existing Data: ${existingData['product']}");
    Map<String, String> selectedAttributes = Map<String, String>.from(existingData['selectedAttributes'] ?? {});
    bool isAuctionEnabled = existingData['isAuctionEnabled'] ?? false;
    TextEditingController bidTimeController = TextEditingController(text: existingData['minAuctionTime']?.toString() ?? '');
    TextEditingController bidPriceController = TextEditingController(text: existingData['minimumBidPrice']?.toString() ?? '');

    double getBottomSheetHeight() {
      double baseHeight = 0.71;
      if (isAuctionEnabled) {
        baseHeight = 0.83;
      }
      if (catalogItems.attributes != null && catalogItems.attributes!.length > 3) {
        baseHeight += 0.1;
      }
      return Get.height * baseHeight;
    }

    bool isDataEmpty() {
      // Check attributes validation
      bool attributesValid = true;
      if (catalogItems.attributes != null && catalogItems.attributes!.isNotEmpty) {
        attributesValid = selectedAttributes.isNotEmpty;
        for (var attribute in catalogItems.attributes!) {
          if (!selectedAttributes.containsKey(attribute.name) || selectedAttributes[attribute.name]?.isEmpty == true) {
            attributesValid = false;
            break;
          }
        }
      }

      // Check auction data validation
      bool auctionDataValid = bidTimeController.text.isNotEmpty && bidPriceController.text.isNotEmpty;

      if (isAuctionEnabled) {
        return !attributesValid || !auctionDataValid; // Both required
      } else {
        return !attributesValid; // Only attributes required
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              bool isEmpty = isDataEmpty();

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: getBottomSheetHeight(),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    10.height,
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            St.editProductDetails.tr,
                            style: AppFontStyle.styleW700(AppColors.white, 18),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                AppAsset.icClose,
                                height: 16,
                                color: AppColors.unselected,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.unselected.withValues(alpha: .5),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.tabBackground,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: catalogItems.mainImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  16.width,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          catalogItems.productName,
                                          style: AppFontStyle.styleW700(AppColors.white, 16),
                                        ),
                                        8.height,
                                        Text(
                                          catalogItems.subCategory.name,
                                          style: AppFontStyle.styleW600(AppColors.unselected, 14),
                                        ),
                                        8.height,
                                        Text(
                                          "$currencySymbol ${catalogItems.price}",
                                          style: AppFontStyle.styleW900(AppColors.primary, 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Product Attributes Selection (same logic but pre-filled)
                            if (catalogItems.attributes.isNotEmpty) ...[
                              Text(
                                "Select Attributes",
                                style: AppFontStyle.styleW700(AppColors.black, 16),
                              ),
                              12.height,
                              ...catalogItems.attributes.map<Widget>((attribute) {
                                List<String> values = [];
                                if (attribute.values is List) {
                                  values = (attribute.values as List).map((e) => e.toString()).toList();
                                } else if (attribute.values is String) {
                                  values = (attribute.values as String).split(',').map((e) => e.trim()).toList();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select ${attribute.name}" ?? "",
                                      style: AppFontStyle.styleW600(AppColors.coloGreyText, 14),
                                    ),
                                    8.height,
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: values.map((value) {
                                        bool isSelected = selectedAttributes[attribute.name] == value.trim();
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedAttributes[attribute.name ?? ""] = value.trim();
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColors.primary : AppColors.coloGreyText.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isSelected ? AppColors.primary : AppColors.coloGreyText.withValues(alpha: 0.1),
                                              ),
                                            ),
                                            child: Text(
                                              value.trim(),
                                              style: AppFontStyle.styleW500(
                                                isSelected ? Colors.black : AppColors.coloGreyText,
                                                12,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ).paddingOnly(bottom: 8);
                              }),
                            ],
                            10.height,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: MainButtonWidget(
                              height: 50,
                              width: Get.width,
                              color: AppColors.red,
                              callback: () {
                                Get.back();
                              },
                              child: Text(
                                St.cancelText.tr,
                                style: AppFontStyle.styleW700(AppColors.white, 16),
                              ),
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: MainButtonWidget(
                              height: 50,
                              width: Get.width,
                              color: isEmpty ? AppColors.unselected.withValues(alpha: 0.3) : AppColors.primary,
                              callback: isEmpty
                                  ? () {}
                                  : () {
                                      if (isAuctionEnabled) {
                                        if (bidTimeController.text.isEmpty || bidPriceController.text.isEmpty) {
                                          Utils.showToast(
                                            "Please fill auction details",
                                          );
                                          return;
                                        }
                                      }
                                      Map<String, dynamic> updatedProductData = {
                                        'productId': catalogItems.id ?? '', // Add this line
                                        'selectedAttributes': selectedAttributes,
                                        'isAuctionEnabled': isAuctionEnabled,
                                        'minAuctionTime': isAuctionEnabled ? bidTimeController.text : null,
                                        'minimumBidPrice': isAuctionEnabled ? bidPriceController.text : null,
                                      };
                                      log("Updated Product Data: $updatedProductData");
                                      logic.updateSelectedProduct(productIndex, updatedProductData, catalogItems);
                                      Get.back();
                                      Utils.showToast("Product updated successfully");
                                    },
                              child: Text(
                                St.updateProduct.tr,
                                style: AppFontStyle.styleW700(isEmpty ? AppColors.unselected : AppColors.black, 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
