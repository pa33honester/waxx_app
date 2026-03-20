import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/View/MyApp/Seller/Reels/shorts_preview.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Controller/ApiControllers/seller/show_catalog_controller.dart';
import '../../../../Controller/GetxController/seller/manage_reels_controller.dart';
import '../../../../Controller/GetxController/seller/show_uploaded_reels_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';
import '../../../../utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import '../../../../utils/globle_veriables.dart';
import '../../../../utils/shimmers.dart';

class UploadedShort extends StatefulWidget {
  const UploadedShort({super.key});

  @override
  State<UploadedShort> createState() => _UploadedShortState();
}

class _UploadedShortState extends State<UploadedShort> {
  ShowCatalogController showCatalogController = Get.put(ShowCatalogController());
  ShowUploadedShortsController showUploadedShortsController = Get.put(ShowUploadedShortsController());
  ManageShortsController manageShortsController = Get.put(ManageShortsController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      _scrollListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showUploadedShortsController.getReels();
      showCatalogController.getCatalogData(saleType: 'All', search: 'All');
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      log("ScrollController Called");
      setState(() {});
      showUploadedShortsController.loadMoreData();
    }
  }

  @override
  void dispose() {
    // scrollController.dispose();
    showUploadedShortsController.reelsItems.clear();
    showUploadedShortsController.start = 1;
    super.dispose();
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      showUploadedShortsController.start = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showUploadedShortsController.getReels();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: Get.width,
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: GeneralTitle(title: St.shorts.tr),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed("/CreateShort")?.then((value) => manageShortsController.isAutoGenerateOn.value = false);
                        },
                        child: Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image(
                              color: isDark.value ? AppColors.white : AppColors.darkGrey,
                              image: const AssetImage("assets/icons/Plus.png"),
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.black,
          onRefresh: () => refreshData(),
          child: GetBuilder<ShowUploadedShortsController>(
            builder: (ShowUploadedShortsController showUploadedShortsController) {
              return showUploadedShortsController.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Shimmers.productGridviewShimmer(),
                    )
                  : showUploadedShortsController.reelsItems.isEmpty
                      ? noDataFound(
                          image: "assets/no_data_found/reels_not_found.png",
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                                  child: Text(St.uploadedShort.tr, style: AppFontStyle.styleW500(Colors.grey, 17)),
                                ),
                                GridView.builder(
                                  controller: scrollController,
                                  cacheExtent: 1000,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: showUploadedShortsController.reelsItems.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 15,
                                    crossAxisCount: 2,
                                    mainAxisExtent: 50 * 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var reelItem = showUploadedShortsController.reelsItems[index];
                                        Get.to(ShortsPreview(
                                          ifUploadedReel: true,
                                          productList: reelItem.productId,
                                          productDescription: reelItem.description,
                                          videoUrl: reelItem.video,
                                        ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: AppColors.tabBackground, borderRadius: BorderRadius.circular(15)),
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: SizedBox(
                                                    height: 180,
                                                    width: double.maxFinite,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                        imageUrl: (showUploadedShortsController.reelsItems[index].productId?.isNotEmpty == true)
                                                            ? showUploadedShortsController.reelsItems[index].productId![0].mainImage.toString()
                                                            : "",
                                                          placeholder: (context, url) => const Center(
                                                              child: CupertinoActivityIndicator(
                                                            animating: true,
                                                          )),
                                                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                                        ),
                                                        Align(alignment: Alignment.center, child: Icon(Icons.play_arrow_rounded, color: AppColors.white, size: 50))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              (showUploadedShortsController.reelsItems[index].productId?.isNotEmpty == true)
                                                                  ? showUploadedShortsController.reelsItems[index].productId![0].productName.toString()
                                                                  : "",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppFontStyle.styleW600(AppColors.lightGrey, 13),
                                                            ),
                                                            Text(
                                                              "$currencySymbol${(showUploadedShortsController.reelsItems[index].productId?.isNotEmpty == true) ? showUploadedShortsController.reelsItems[index].productId![0].price : ""}",
                                                              style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 14, fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // const Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.defaultDialog(
                                                            backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                                                            title: St.kindlyVerifyYourDecisionToDeleteTheShort.tr,
                                                            titlePadding: const EdgeInsets.only(top: 35),
                                                            titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, height: 1.5, fontSize: 17, fontWeight: FontWeight.w600),
                                                            content: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: Get.height / 30,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                                                  child: PrimaryPinkButton(
                                                                      onTaped: () {
                                                                        Get.back();
                                                                      },
                                                                      text: St.cancelSmallText.tr),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 18, bottom: 10),
                                                                  child: SizedBox(
                                                                    height: 20,
                                                                    child: Obx(
                                                                      () => manageShortsController.deleteReelLoading.value
                                                                          ? const CupertinoActivityIndicator()
                                                                          : GestureDetector(
                                                                              onTap: () async {
                                                                                manageShortsController.deleteReel(reelId: "${showUploadedShortsController.reelsItems[index].id}");
                                                                              },
                                                                              child: Text(
                                                                                St.delete.tr,
                                                                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 31,
                                                          width: 31,
                                                          decoration: BoxDecoration(shape: BoxShape.circle, color: isDark.value ? AppColors.blackBackground : AppColors.white),
                                                          child: Image.asset("assets/icons/Delete.png").paddingAll(7.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).paddingOnly(bottom: 10),
                                    );
                                  },
                                ),
                              ],
                            ).paddingOnly(bottom: 20),
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
