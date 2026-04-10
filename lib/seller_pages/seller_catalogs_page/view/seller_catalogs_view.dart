import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/show_catalog_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerCatalogsView extends StatefulWidget {
  const SellerCatalogsView({super.key});

  @override
  State<SellerCatalogsView> createState() => _SellerCatalogsViewState();
}

class _SellerCatalogsViewState extends State<SellerCatalogsView> {
  ShowCatalogController showCatalogController = Get.put(ShowCatalogController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      _scrollListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCatalogController.getCatalogData(search: 'All', saleType: 'All');
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {});
      showCatalogController.loadMoreData();
    }
  }

  @override
  void dispose() {
    showCatalogController.catalogItems.clear();
    showCatalogController.start = 1;
    super.dispose();
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      showCatalogController.start = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCatalogController.getCatalogData(saleType: "All", search: "All");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: const SellerCatalogsAppBarWidget(),
          ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: RefreshIndicator(
            onRefresh: refreshData,
            child: Stack(
              children: [
                Obx(
                  () => showCatalogController.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Shimmers.justForYouProductsShimmer(),
                        )
                      : showCatalogController.catalogItems.isEmpty
                          ? noDataFound(image: "assets/no_data_found/basket.png", text: St.noProductFound.tr)
                          : GetBuilder<ShowCatalogController>(
                              builder: (ShowCatalogController showCatalogController) {
                                return ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: showCatalogController.catalogItems.length,
                                  itemBuilder: (context, index) {
                                    var catalogItems = showCatalogController.catalogItems[index];
                                    return GestureDetector(
                                      onTap: () {
                                        productId = "${catalogItems.id}";
                                        Get.toNamed("/SellerProductDetails");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.tabBackground,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              padding: EdgeInsets.all(8),
                                              clipBehavior: Clip.hardEdge,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: catalogItems.mainImage ?? "",
                                                  placeholder: (context, url) => Image.asset(
                                                    AppAsset.categoryPlaceholder,
                                                    height: 22,
                                                  ),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    AppAsset.categoryPlaceholder,
                                                    height: 22,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            catalogItems.productName?.capitalizeFirst ?? "",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: AppConstant.appFontRegular,
                                                              color: AppColors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                            color: catalogItems.createStatus == "Approved"
                                                                ? AppColors.greenBackground
                                                                : catalogItems.createStatus == "Pending"
                                                                    ? AppColors.redBackground
                                                                    : AppColors.greyGreenBackground,
                                                          ),
                                                          child: Text(
                                                            "${catalogItems.createStatus}",
                                                            style: AppFontStyle.styleW500(
                                                              catalogItems.createStatus == "Approved"
                                                                  ? AppColors.green
                                                                  : catalogItems.createStatus == "Pending"
                                                                      ? AppColors.red
                                                                      : AppColors.primary,
                                                              11,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    6.height,
                                                    Text(
                                                      catalogItems.description!.capitalizeFirst ?? "",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: AppConstant.appFontRegular,
                                                        color: AppColors.unselected,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    8.height,
                                                    if (catalogItems.attributes != null && catalogItems.attributes!.isNotEmpty)
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ...catalogItems.attributes!
                                                              .where((attribute) {
                                                                if (attribute.values == null) return false;

                                                                if (attribute.values is List) {
                                                                  return (attribute.values as List).isNotEmpty;
                                                                } else {
                                                                  return attribute.values.toString().trim().isNotEmpty;
                                                                }
                                                              })
                                                              .take(1)
                                                              .map((attribute) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(bottom: 3),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "${attribute.name}: ",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: AppConstant.appFontRegular,
                                                                                  color: AppColors.unselected,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: attribute.values is List ? (attribute.values as List).join(", ") : "${attribute.values}",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: AppConstant.appFontRegular,
                                                                                  color: AppColors.primary,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                              .toList(),
                                                        ],
                                                      ),
                                                    4.height,
                                                    Text(
                                                      "$currencySymbol${catalogItems.price}",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontFamily: AppConstant.appFontRegular,
                                                        color: AppColors.primary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(
                      () => showCatalogController.moreLoading.value
                          ? Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.40)),
                              child: const Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellerCatalogsAppBarWidget extends StatelessWidget {
  const SellerCatalogsAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
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
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(AppAsset.icBack, width: 15),
                ),
              ),
              80.width,
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    St.catelogs.tr,
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
