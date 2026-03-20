import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ApiModel/seller/ShowUploadedReelsModel.dart';
import '../../../Controller/ApiControllers/seller/show_catalog_controller.dart';
import '../../../Controller/GetxController/seller/manage_reels_controller.dart';
import '../../globle_veriables.dart';
import '../../shimmers.dart';

class SelectProductWhenCreateReels extends StatefulWidget {
  const SelectProductWhenCreateReels({super.key});

  @override
  State<SelectProductWhenCreateReels> createState() => _SelectProductWhenCreateReelsState();
}

class _SelectProductWhenCreateReelsState extends State<SelectProductWhenCreateReels> {
  ShowCatalogController showCatalogController = Get.put(ShowCatalogController());
  ManageShortsController manageShortsController = Get.put(ManageShortsController());
  ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // scrollController.addListener(_scrollListener);
    // _searchController.addListener(_onSearchChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCatalogController.getCatalogData(saleType: 'All', search: '');
    });

    super.initState();
  }

  @override
  void dispose() {
    // scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    // _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      log("ScrollController Called - Load more data");
      showCatalogController.loadMoreData();
    }
  }

  void _onSearchChanged() {
    final searchText = _searchController.text.trim();
    log("Searching for: $searchText");
    showCatalogController.start = 1;
    showCatalogController.catalogItems.clear();

    showCatalogController.getCatalogData(saleType: 'All', search: searchText.isEmpty ? 'All' : searchText);
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      showCatalogController.start = 1;
      showCatalogController.catalogItems.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCatalogController.getCatalogData(saleType: 'All', search: _searchController.text.trim().isEmpty ? 'All' : _searchController.text.trim());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          surfaceTintColor: AppColors.transparent,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.addProduct.tr),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 30,
                  width: 65,
                  decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text(
                    St.done.tr,
                    style: AppFontStyle.styleW500(AppColors.black, 12),
                  )),
                ).paddingOnly(right: 16),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            10.height,
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected.withValues(alpha: 0.5)),
                  10.width,
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.unselected,
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      style: AppFontStyle.styleW500(AppColors.white, 15),
                      decoration: InputDecoration(
                        hintText: St.searchText.tr,
                        hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        final searchText = value.trim();
                        showCatalogController.start = 1;
                        showCatalogController.catalogItems.clear();
                        showCatalogController.getCatalogData(saleType: 'All', search: searchText.isEmpty ? 'All' : searchText);
                      },
                    ),
                  ),
                ],
              ),
            ),
            10.height,
            Expanded(
              child: Obx(
                () => showCatalogController.isLoading.value && showCatalogController.catalogItems.isEmpty
                    ? Shimmers.justForYouProductsShimmer()
                    : showCatalogController.catalogItems.isEmpty
                        ? Center(
                            child: noDataFound(
                            image: "assets/no_data_found/basket.png",
                          ))
                        : RefreshIndicator(
                            onRefresh: refreshData,
                            child: ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              itemCount: showCatalogController.catalogItems.length,
                              itemBuilder: (context, index) {
                                if (index >= showCatalogController.catalogItems.length) {
                                  // Show loading indicator at the bottom
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CupertinoActivityIndicator(color: AppColors.primary),
                                    ),
                                  );
                                }

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      final currentItem = showCatalogController.catalogItems[index];

                                      ProductId productData = ProductId(
                                        id: currentItem.id,
                                        productName: currentItem.productName,
                                        mainImage: currentItem.mainImage,
                                        price: currentItem.price?.toInt(),
                                        description: currentItem.description,
                                        seller: currentItem.seller?.id,
                                        productCode: currentItem.productCode,
                                        shippingCharges: currentItem.shippingCharges?.toInt(),
                                        createStatus: currentItem.createStatus,
                                        attributes: currentItem.attributes
                                            ?.map((attr) => Attribute(
                                                  name: attr.name,
                                                  values: attr.values,
                                                ))
                                            .toList(),
                                      );

                                      // Toggle selection
                                      manageShortsController.toggleSelection(index, currentItem.id.toString(), productData);
                                      log("Selected Products: ${manageShortsController.selectedProductIds}");
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.tabBackground,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: showCatalogController.catalogItems[index].mainImage.toString(),
                                            placeholder: (context, url) => const Center(
                                                child: CupertinoActivityIndicator(
                                              animating: true,
                                            )),
                                            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 7, left: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  showCatalogController.catalogItems[index].productName.toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW700(AppColors.white, 14),
                                                ),
                                                6.height,
                                                Text(
                                                  showCatalogController.catalogItems[index].description ?? "",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                ),
                                                6.height,
                                                Text(
                                                  "$currencySymbol${showCatalogController.catalogItems[index].price}",
                                                  style: AppFontStyle.styleW700(AppColors.primary, 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        8.width,
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: manageShortsController.isSelected(index) ? AppColors.primary : Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: manageShortsController.isSelected(index) ? null : Border.all(color: AppColors.white),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.done,
                                                  size: 15,
                                                  color: manageShortsController.isSelected(index) ? Colors.black : Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
