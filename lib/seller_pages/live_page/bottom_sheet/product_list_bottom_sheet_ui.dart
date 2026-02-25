import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/seller_pages/live_page/controller/live_controller.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../custom/circle_icon_button_ui.dart';
import '../../../utils/database.dart';

class ProductListBottomSheetUi {
  static void show({
    required BuildContext context,
    required bool isHost,
    String? title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => Container(
        height: Get.height * .70,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: GetBuilder<LiveController>(
          init: Get.put(LiveController()),
          builder: (logic) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 8, right: 16),
                  child: Container(
                    // color: AppColors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          title ?? "Available Products",
                          style: AppFontStyle.styleW700(AppColors.white, 16),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleIconButtonUi(
                              color: AppColors.black.withValues(alpha: 0.8),
                              icon: AppAsset.icClose,
                              iconColor: AppColors.white,
                              circleSize: 30,
                              iconSize: 16,
                              callback: () => Get.back(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColors.unselected.withValues(alpha: .5),
                ),
                Expanded(
                  child: logic.liveSelectedProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: AppColors.coloGreyText,
                              ),
                              16.height,
                              Text(
                                St.txtNoProductFound.tr,
                                style: AppFontStyle.styleW600(
                                  AppColors.coloGreyText,
                                  16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: ListView.builder(
                            itemCount: logic.liveSelectedProducts.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 16,
                              right: 16,
                              bottom: 20,
                            ),
                            itemBuilder: (context, index) {
                              final data = logic.liveSelectedProducts[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.unselected.withValues(alpha: 0.2),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: ProductsUi(
                                  selectedProduct: data,
                                  sellerId: logic.sellerId,
                                  liveType: logic.liveType,
                                ),
                              );
                            },
                          ),
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

class ProductsUi extends StatelessWidget {
  ProductsUi({
    super.key,
    required this.selectedProduct,
    required this.sellerId,
    required this.liveType,
  });

  final SelectedProduct selectedProduct;
  final String sellerId;
  final int liveType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Database.sellerId != sellerId) {
          productId = selectedProduct.productId.toString() ?? "";
          Get.toNamed("/ProductDetail");
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PreviewImageWidget(
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            image: selectedProduct.mainImage ?? "",
            radius: 12,
            errorWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                AppAsset.categoryPlaceholder,
              ),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  selectedProduct.productName ?? "Product Name",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                ),
                Text(
                  "$currencySymbol ${selectedProduct.price ?? 0}",
                  style: AppFontStyle.styleW900(AppColors.primary, 16),
                ),
                if (selectedProduct.productAttributes != null && selectedProduct.productAttributes!.isNotEmpty) ...[
                  Column(
                    spacing: 4,
                    children: selectedProduct.productAttributes!
                        .take(2)
                        .map((attribute) => Row(
                              children: [
                                Text(
                                  "${attribute.name} : ",
                                  style: AppFontStyle.styleW500(AppColors.white, 12),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.unselected.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                    color: AppColors.unselected.withValues(alpha: 0.3),
                                  ),
                                  child: Text(
                                    attribute.values.join(", "),
                                    style: AppFontStyle.styleW500(AppColors.white, 12),
                                  ),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),

                // Buy Button (only show for non-sellers)
                if (Database.sellerId != sellerId && liveType == 1)
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Database.sellerId != sellerId) {
                          Get.close(2);
                          productId = selectedProduct.productId.toString() ?? "";
                          Get.toNamed("/ProductDetail");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        "BUY NOW",
                        style: AppFontStyle.styleW700(AppColors.black, 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
