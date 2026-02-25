import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/ApiControllers/seller/show_catalog_controller.dart';
import 'package:era_shop/Controller/GetxController/seller/live_select_product_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_circular.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/GetxController/seller/live_seller_for_selling_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';
import '../../../../utils/CoustomWidget/jump_to_live.dart';
import '../../../../utils/Zego/ZegoUtils/permission.dart';
import '../../../../utils/shimmers.dart';

class LiveStreaming extends StatefulWidget {
  const LiveStreaming({super.key});

  @override
  State<LiveStreaming> createState() => _LiveStreamingState();
}

class _LiveStreamingState extends State<LiveStreaming> with TickerProviderStateMixin {
  ShowCatalogController showCatalogController = Get.put(ShowCatalogController());
  LiveSelectProductController liveSelectProductController = Get.put(LiveSelectProductController());
  LiveSellerForSellingController liveSellerForSellingController = Get.put(LiveSellerForSellingController());
  ScrollController scrollController = ScrollController();

  bool isNavigate = false;

  final List<bool> selected = List.generate(100000, (_) => false);

  @override
  void initState() {
    scrollController.addListener(() {
      log("scrollController");
      _scrollListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCatalogController.getCatalogData(search: 'All', saleType: "All");
      isDemoSeller == true ? requestPermission() : null;
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      log("ScrollController Called");
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //   child: PrimaryPinkButton(
          //       onTaped: () async {
          //         // createEngine();
          //
          //         await liveSellerForSellingController.sellerLiveForSelling();
          //         var liveSellerData = liveSellerForSellingController.liveSellerForSelling?.liveseller;
          //
          //         log("liveSellingHistoryId :: ${liveSellerData!.liveSellingHistoryId}");
          //         log("localUserID :: ${liveSellerData.sellerId}");
          //         log("localUserName :: ${liveSellerData.firstName}");
          //         liveSellerForSellingController.liveSellerForSelling!.status == true
          //             // ignore: use_build_context_synchronously
          //             ? jumpToLivePage(
          //                 context,
          //                 roomID: "${liveSellerData.liveSellingHistoryId}",
          //                 isHost: true,
          //                 localUserID: "${liveSellerData.sellerId}",
          //                 localUserName: "${liveSellerData.firstName}",
          //               )
          //             : displayToast(message: St.somethingWentWrong.tr);
          //       },
          //       text: St.goLive.tr),
          // ),
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(60),
          //   child: AppBar(
          //     elevation: 0,
          //     automaticallyImplyLeading: false,
          //     actions: [
          //       SizedBox(
          //         width: Get.width,
          //         height: double.maxFinite,
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 15),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 10),
          //                 child: PrimaryRoundButton(
          //                     onTaped: () {
          //                       Get.off(const SellerProfileView(), transition: Transition.leftToRight);
          //                       // Get.back();
          //                     },
          //                     icon: Icons.arrow_back_rounded),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 7),
          //                 child: GeneralTitle(title: St.liveStemming.tr),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(left: 15),
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     Get.offNamed("/AddProduct", arguments: isNavigate = true);
          //                   },
          //                   child: Obx(
          //                     () => Padding(
          //                       padding: const EdgeInsets.only(top: 10),
          //                       child: Image(
          //                         color: isDark.value ? AppColors.white : AppColors.darkGrey,
          //                         image: const AssetImage("assets/icons/Plus.png"),
          //                         height: 25,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              surfaceTintColor: AppColors.transparent,
              flexibleSpace: SellerLiveAppBarWidget(),
            ),
          ),
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Obx(
              () => showCatalogController.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Shimmers.productGridviewShimmer(),
                    )
                  : showCatalogController.catalogItems.isEmpty
                      ? noDataFound(image: "assets/no_data_found/basket.png", text: St.noProductFound.tr)
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                                  child: Text(St.selectProduct.tr, style: AppFontStyle.styleW700(AppColors.white, 17)),
                                ),
                                GridView.builder(
                                  controller: scrollController,
                                  cacheExtent: 1000,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: showCatalogController.catalogItems.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    mainAxisExtent: 240,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected[index] = !selected[index];
                                          showCatalogController.toggleProductSelection(
                                            showCatalogController.catalogItems[index],
                                            selected[index],
                                          );
                                          // selected[index] = !selected[index];
                                          //
                                          // productId = "${showCatalogController.catalogItems[index].id}";
                                          //
                                          // selected[index] ? liveSelectProductController.getSelectedProductData() : !selected[index];
                                          //
                                          // !selected[index] ? liveSelectProductController.getSelectedProductData() : selected[index];
                                          //
                                          // selected[index] == true
                                          //     ? showCatalogController.selectedCatalogId.add(showCatalogController.catalogItems[index].id)
                                          //     : showCatalogController.selectedCatalogId.remove(showCatalogController.catalogItems[index].id);
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.tabBackground,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    height: 180,
                                                    width: double.maxFinite,
                                                    fit: BoxFit.cover,
                                                    imageUrl: showCatalogController.catalogItems[index].mainImage.toString(),
                                                    placeholder: (context, url) => const Center(
                                                        child: CupertinoActivityIndicator(
                                                      animating: true,
                                                    )),
                                                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 7, left: 10),
                                                  child: Text(
                                                    showCatalogController.catalogItems[index].productName.toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppFontStyle.styleW700(AppColors.white, 11),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 7, left: 10),
                                                  child: Text(
                                                    "$currencySymbol${showCatalogController.catalogItems[index].price}",
                                                    style: AppFontStyle.styleW800(AppColors.primary, 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: showCatalogController.catalogItems[index].isSelect == true & selected[index] ? null : AppColors.primary,
                                                  shape: BoxShape.circle,
                                                  border: showCatalogController.catalogItems[index].isSelect == true & selected[index] ? Border.all(color: AppColors.white) : null,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.done,
                                                    size: 15,
                                                    color: showCatalogController.catalogItems[index].isSelect == true & selected[index] ? Colors.transparent : AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Align(
                                          //   alignment: Alignment.topRight,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Image(
                                          //       image: showCatalogController.catalogItems[index].isSelect == true & selected[index]
                                          //           ? const AssetImage("assets/icons/round check.png")
                                          //           : const AssetImage("assets/icons/round_cheak_selected.png"),
                                          //       height: 20,
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          ),
          bottomNavigationBar: MainButtonWidget(
            height: 55,
            width: Get.width,
            margin: const EdgeInsets.all(15),
            color: AppColors.primary,
            child: Text(
              St.goLive.tr.toUpperCase(),
              style: AppFontStyle.styleW700(AppColors.black, 16),
            ),
            callback: () async {
              // createEngine();

              if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                displayToast(message: St.thisIsDemoUser.tr);
                return;
              }

              // Get selected products
              final selectedProducts = showCatalogController.selectedProducts;

              // Call API with selected products
              await liveSellerForSellingController.sellerLiveForSelling(selectedProducts: selectedProducts);

              // await liveSellerForSellingController.sellerLiveForSelling();
              var liveSellerData = liveSellerForSellingController.liveSellerForSelling?.liveseller;

              log("liveSellingHistoryId :: ${liveSellerData!.liveSellingHistoryId}");
              log("localUserID :: ${liveSellerData.sellerId}");
              log("localUserName :: ${liveSellerData.firstName}");
              liveSellerForSellingController.liveSellerForSelling!.status == true
                  // ignore: use_build_context_synchronously
                  ? jumpToLivePage(
                      context,
                      roomID: "${liveSellerData.liveSellingHistoryId}",
                      isHost: true,
                      localUserID: "${liveSellerData.sellerId}",
                      localUserName: "${liveSellerData.firstName}",
                    )
                  : displayToast(message: St.somethingWentWrong.tr);
            },
          ),
        ),
        Obx(
          () => liveSellerForSellingController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox(),
        ),
      ],
    );
  }
}

class SellerLiveAppBarWidget extends StatelessWidget {
  const SellerLiveAppBarWidget({super.key});

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
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    St.liveStemming.tr,
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                ),
              ),
              // 9.width,
              // GestureDetector(
              //   onTap: () {
              //     Get.toNamed("/AddProduct", arguments: true);
              //   },
              //   child: Image(
              //     color: AppColors.white,
              //     image: const AssetImage("assets/icons/Plus.png"),
              //     height: 22,
              //   ),
              // ),
              40.width,
            ],
          ),
        ),
      ),
    );
  }
}
