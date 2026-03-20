import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/controller/select_product_for_controller.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/model/fetch_product_model.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductDetailsBottomSheet {
  static void show(BuildContext context, InventoryProduct catalogItems, SelectProductsForStreamerController logic) {
    Map<String, String> selectedAttributes = {};
    bool isAuctionEnabled = false;
    TextEditingController bidTimeController = TextEditingController();
    TextEditingController bidPriceController = TextEditingController();

    double getBottomSheetHeight() {
      double baseHeight = 0.58;

      if (isAuctionEnabled) {
        baseHeight = 0.83;
      }
      if (catalogItems.attributes.length > 3) {
        baseHeight += 0.1;
      }

      return Get.height * baseHeight;
    }

    bool isDataEmpty() {
      bool hasRequiredAttributes = catalogItems.attributes.isNotEmpty;
      bool allAttributesSelected = true;
      if (hasRequiredAttributes) {
        for (var attribute in catalogItems.attributes) {
          if (!selectedAttributes.containsKey(attribute.name) || selectedAttributes[attribute.name]?.isEmpty == true) {
            allAttributesSelected = false;
            break;
          }
        }
      }

      bool auctionDataValid = true;
      if (isAuctionEnabled) {
        auctionDataValid = bidTimeController.text.isNotEmpty && bidPriceController.text.isNotEmpty;
      }

      if (isAuctionEnabled) {
        if (hasRequiredAttributes) {
          return !allAttributesSelected || !auctionDataValid;
        } else {
          return !auctionDataValid;
        }
      } else {
        if (hasRequiredAttributes) {
          return !allAttributesSelected;
        } else {
          return false;
        }
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
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: const BorderRadius.only(
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
                            St.productDetails.tr,
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
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: catalogItems.mainImage,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        AppAsset.categoryPlaceholder,
                                        height: 50,
                                        width: 50,
                                        color: AppColors.unselected,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        AppAsset.categoryPlaceholder,
                                        height: 50,
                                        width: 50,
                                        color: AppColors.unselected,
                                      ),
                                    ),
                                  ),
                                  12.width,
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
                                          style: AppFontStyle.styleW800(AppColors.primary, 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            20.height,
                            if (catalogItems.attributes.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.unselected.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.tune,
                                            color: AppColors.unselected,
                                            size: 20,
                                          ),
                                        ),
                                        12.width,
                                        Text(
                                          St.selectAttributes.tr,
                                          style: AppFontStyle.styleW700(AppColors.white, 18),
                                        ),
                                      ],
                                    ),
                                    16.height,
                                    ...catalogItems.attributes.map<Widget>(
                                      (attribute) {
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
                                              "Select ${attribute.name}",
                                              style: AppFontStyle.styleW600(AppColors.unselected, 14),
                                            ),
                                            12.height,
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: values.map((value) {
                                                bool isSelected = selectedAttributes[attribute.name] == value.trim();
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedAttributes[attribute.name] = value.trim();
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.15),
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color: isSelected ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      value.trim(),
                                                      style: AppFontStyle.styleW600(
                                                        isSelected ? AppColors.background : AppColors.white,
                                                        14,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            4.height,
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              20.height,
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.unselected.withValues(alpha: .5),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
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
                                  ? null
                                  : () {
                                      if (isAuctionEnabled) {
                                        if (bidTimeController.text.isEmpty || bidPriceController.text.isEmpty) {
                                          Utils.showToast("Please fill auction details");
                                          return;
                                        }
                                      }
                                      Map<String, dynamic> productData = {
                                        'selectedAttributes': selectedAttributes,
                                        'isAuctionEnabled': isAuctionEnabled,
                                        'minAuctionTime': isAuctionEnabled ? bidTimeController.text : null,
                                        'minimumBidPrice': isAuctionEnabled ? bidPriceController.text : null,
                                      };

                                      logic.onAddProductFromBottomSheet(productData, catalogItems);
                                    },
                              child: Text(
                                St.addProduct.tr,
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
