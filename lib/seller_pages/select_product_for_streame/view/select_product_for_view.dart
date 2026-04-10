import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/bottom_sheet/add_product_details_bottom_sheet.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/bottom_sheet/show_selected_products_bottom_sheet.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/controller/select_product_for_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProductForStreamView extends StatelessWidget {
  SelectProductForStreamView({super.key});

  SelectProductsForStreamerController selectProductsForStreamerController = Get.put(SelectProductsForStreamerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: AppColors.black.withValues(alpha: 0.4),
        surfaceTintColor: AppColors.transparent,
        flexibleSpace: SimpleAppBarWidget(title: St.txtSelectProduct.tr),
      ),
      body: GetBuilder<SelectProductsForStreamerController>(
        id: "onGetProducts",
        builder: (logic) {
          return RefreshIndicator(
            onRefresh: () {
              return logic.onRefresh();
            },
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSearchBar(logic),
                        22.height,
                        Expanded(
                          child: logic.isLoading
                              ? ProductListViewShimmer()
                              : logic.productList.isEmpty
                                  ? noDataFound(image: "assets/no_data_found/basket.png")
                                  : ListView.builder(
                                      controller: logic.scrollController,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: logic.productList.length,
                                      itemBuilder: (context, index) {
                                        var catalogItems = logic.productList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            AddProductDetailsBottomSheet.show(context, catalogItems, logic);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(bottom: 15),
                                            decoration: BoxDecoration(
                                              color: AppColors.tabBackground,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 110,
                                                      height: 110,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: catalogItems.mainImage,
                                                        fit: BoxFit.cover,
                                                        height: 100,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey.withValues(alpha: 0.02),
                                                          child: Center(
                                                            child: Image.asset(AppAsset.categoryPlaceholder, height: 70, width: 70, color: AppColors.coloGreyText),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: Colors.grey.withValues(alpha: 0.5),
                                                          child: Center(
                                                            child: Image.asset(AppAsset.categoryPlaceholder, height: 70, width: 70, color: AppColors.coloGreyText),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    6.width,
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed from mainAxisSize.min
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  catalogItems.productName,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: AppFontStyle.styleW700(AppColors.white, 16),
                                                                ),
                                                                6.height,
                                                                Text(
                                                                  catalogItems.subCategory.name,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.8), 12),
                                                                ),
                                                                6.height,
                                                                if (catalogItems.attributes.isNotEmpty) ...[
                                                                  ...catalogItems.attributes.take(2).map(
                                                                        (attribute) => SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "${attribute.name} :",
                                                                                style: AppFontStyle.styleW700(AppColors.white, 12),
                                                                              ),
                                                                              4.width,
                                                                              Wrap(
                                                                                spacing: 4,
                                                                                runSpacing: 2,
                                                                                children: attribute.values!
                                                                                    .map<Widget>((value) => Container(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppColors.primary.withValues(alpha: 0.1),
                                                                                            borderRadius: BorderRadius.circular(4),
                                                                                            border: Border.all(
                                                                                              color: AppColors.primary.withValues(alpha: 0.3),
                                                                                              width: 0.5,
                                                                                            ),
                                                                                          ),
                                                                                          child: Text(
                                                                                            value.toString(),
                                                                                            style: AppFontStyle.styleW500(AppColors.primary, 11),
                                                                                          ),
                                                                                        ))
                                                                                    .toList(),
                                                                              ),
                                                                              const SizedBox(height: 8),
                                                                            ],
                                                                          ).paddingOnly(bottom: 4),
                                                                        ),
                                                                      ),
                                                                ],
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                8.height,
                                                Container(
                                                  height: 1,
                                                  color: AppColors.unselected.withValues(alpha: .5),
                                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      St.totalAmount.tr,
                                                      style: AppFontStyle.styleW600(AppColors.unselected, 14),
                                                    ),
                                                    Text(
                                                      "$currencySymbol ${catalogItems.price}",
                                                      style: AppFontStyle.styleW900(AppColors.primary, 16),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                  GetBuilder<SelectProductsForStreamerController>(
                    id: "onPagination",
                    builder: (logic) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: logic.isPaginationLoading
                              ? Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.black.withValues(alpha: 0.40)),
                                  child: Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<SelectProductsForStreamerController>(
        id: "onGetSelectedProducts",
        builder: (controller) {
          return Row(
            children: [
              if (controller.selectedProductsArray.isNotEmpty) ...[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 16),
                    child: AppButtonUi(
                      height: 50,
                      title: "${St.show.tr} (${controller.selectedProductsArray.length})",
                      color: AppColors.black,
                      fontColor: AppColors.primary,
                      borderColor: AppColors.primary,
                      callback: () {
                        ShowSelectedProductsBottomSheet.show(controller); // Show selected products
                      },
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: AppButtonUi(
                    height: 50,
                    fontSize: 18,
                    borderColor: AppColors.primary,
                    color: AppColors.primary,
                    title: St.txtGoLive.tr,
                    fontColor: AppColors.black,
                    callback: () => isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : controller.onRequestPermissions(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(SelectProductsForStreamerController logic) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: logic.searchController,
        onChanged: (value) {
          logic.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: St.searchProducts.tr,
          hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected.withValues(alpha: 0.5)),
          ),
          suffixIcon: logic.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    logic.clearSearch();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.coloGreyText.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: AppColors.coloGreyText,
                      size: 18,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: AppFontStyle.styleW500(AppColors.white, 14),
      ),
    );
  }
}
