import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/just_for_you_prroduct_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/new_collection_controller.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/circle_dotted_border_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_view.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controller/GetxController/socket controller/user_get_selected_product_controller.dart';
import '../../../Controller/GetxController/user/get_reels_controller.dart';
import '../../Zego/ZegoUtils/permission.dart';

class HomePageNewCollection extends StatefulWidget {
  const HomePageNewCollection({super.key});

  @override
  State<HomePageNewCollection> createState() => _HomePageNewCollectionState();
}

class _HomePageNewCollectionState extends State<HomePageNewCollection> {
  NewCollectionController newCollectionController = Get.put(NewCollectionController());

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    // createEngine();
    requestPermission();
    newCollectionController.getNewCollectionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GeneralTitle(title: St.newCollection.tr),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
              height: 225,
              child: GetBuilder<NewCollectionController>(builder: (NewCollectionController controller) {
                return Obx(
                  () => controller.isLoading.value
                      ? Shimmers.listViewProductHorizontal()
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(left: 18),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.getNewCollection!.products!.length,
                          itemBuilder: (context, index) {
                            var products = controller.getNewCollection!.products![index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  productId = "${products.id}";
                                  Get.toNamed("/ProductDetail")!.then((value) => controller.getNewCollectionData());
                                },
                                child: SizedBox(
                                  width: 152,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              height: 178,
                                              width: double.maxFinite,
                                              fit: BoxFit.cover,
                                              imageUrl: products.mainImage.toString(),
                                              placeholder: (context, url) => const Center(
                                                  child: CupertinoActivityIndicator(
                                                animating: true,
                                              )),
                                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                            ),
                                          ),
                                          Text(
                                            products.productName.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "$currencySymbol${products.price}",
                                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              /*log("Product ID ${getNewCollectionController.catalogItems[index].id}");
                                                  log("Category  ID ${getNewCollectionController.catalogItems[index].category}");*/

                                              controller.likeDislike(index);

                                              controller.postFavoriteData(productId: "${products.id}", categoryId: "${products.category}");
                                            },
                                            child: Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image(
                                                  image: products.isFavorite == true & controller.likes[index] ? AssetImage(AppImage.productLike) : AssetImage(AppImage.productDislike),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              })),
        ),
      ],
    );
  }
}

homePageAppBar(BuildContext context) {
  return Container(
    height: 60,
    width: Get.width,
    margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.offAll(BottomBarController());
            final controller = Get.put(BottomBarController());
            controller.onChangeBottomBar(4);
          },
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white),
                ),
                child: Container(
                  height: 48,
                  width: 48,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: imageXFile == null ? Image.network(editImage) : Image.file(File(imageXFile?.path ?? "")),
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneralTitle(title: "${St.hi.tr},$editFirstName"),
                  Text(
                    St.exploreTheLatestLiveDeals.tr,
                    style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        10.width,
        CircleButtonWidget(
          callback: () {},
          size: 42,
          color: AppColors.white.withValues(alpha: 0.2),
          child: Image.asset(AppAsset.icSearch, width: 22),
        ),
        10.width,
        CircleButtonWidget(
          callback: () => Get.toNamed("/Notifications"),
          size: 42,
          color: AppColors.white.withValues(alpha: 0.2),
          child: Image.asset(AppAsset.icNotification, width: 22),
        ),
      ],
    ),
  );
}

class HomePageLiveSelling extends StatefulWidget {
  const HomePageLiveSelling({super.key});

  @override
  State<HomePageLiveSelling> createState() => _HomePageLiveSellingState();
}

class _HomePageLiveSellingState extends State<HomePageLiveSelling> {
  ScrollController scrollController = ScrollController();
  GetLiveSellerListController getLiveSellerListController = Get.put(GetLiveSellerListController());
  UserGetSelectedProductController userGetSelectedProductController = Get.put(UserGetSelectedProductController());

  @override
  void initState() {
    scrollController.addListener(() {
      _scrollListener();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLiveSellerListController.getSellerList();
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {});
      getLiveSellerListController.loadMoreData();
    }
  }

  @override
  void dispose() {
    getLiveSellerListController.getSellerLiveList.clear();
    getLiveSellerListController.start = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!getLiveSellerListController.isLoading.value && getLiveSellerListController.getSellerLiveList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 10.height,
            Row(
              children: [
                Image.asset(AppAsset.icStar_4, width: 20),
                10.width,
                GeneralTitle(title: St.liveSelling.tr),
              ],
            ),
            10.height,
            SizedBox(
              height: Get.height / 13,
              width: Get.width,
              child: Obx(
                () => getLiveSellerListController.isLoading.value
                    ? Shimmers.liveSellerShow()
                    : getLiveSellerListController.getSellerLiveList.isEmpty
                        ? Container(
                            width: Get.width,
                            decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite, borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                "No live seller available",
                                style: AppFontStyle.styleW400(isDark.value ? AppColors.darkGrey : AppColors.mediumGrey, 15),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 15, vertical: 6)
                        : GetBuilder(
                            builder: (GetLiveSellerListController getLiveSellerListController) => ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: getLiveSellerListController.getSellerLiveList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final liveData = getLiveSellerListController.getSellerLiveList[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: Get.width / 23),
                                  child: SizedBox(
                                    height: 66,
                                    width: 66,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => LivePageView(
                                            key: ValueKey("live_${liveData.liveSellingHistoryId}_$index"),
                                            liveUserList: liveData,
                                            isHost: false,
                                            isActive: true,
                                          ),
                                          routeName: '/LivePage',
                                        )?.then((value) async {
                                          await getLiveSellerListController.getSellerList();
                                        });
                                      },
                                      child: CircleDottedBorderWidget(
                                        size: 50,
                                        child: PreviewProfileImageWidget(
                                          size: 50,
                                          fit: BoxFit.cover,
                                          image: getLiveSellerListController.getSellerLiveList[index].image.toString(),
                                        ),
                                      ),
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
      );
    });
  }
}

class HomepageJustForYou extends StatefulWidget {
  final bool isShowTitle;

  const HomepageJustForYou({super.key, required this.isShowTitle});

  @override
  State<HomepageJustForYou> createState() => _HomepageJustForYouState();
}

class _HomepageJustForYouState extends State<HomepageJustForYou> {
  JustForYouProductController justForYouProductController = Get.put(JustForYouProductController());

  @override
  void initState() {
    super.initState();
    justForYouProductController.getJustForYouProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if the list is empty or null
      final isEmpty = justForYouProductController.justForYouProduct?.justForYouProducts == null || justForYouProductController.justForYouProduct!.justForYouProducts!.isEmpty;

      // If the list is empty, return an empty container
      if (isEmpty && !justForYouProductController.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isShowTitle == true ? GeneralTitle(title: St.justForYou.tr) : const SizedBox.shrink(),
            12.height,
            justForYouProductController.isLoading.value
                ? Shimmers.catalogProductShimmer()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: justForYouProductController.justForYouProduct?.justForYouProducts?.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var products = justForYouProductController.justForYouProduct?.justForYouProducts?[index];
                      return GestureDetector(
                        onTap: () {
                          productId = products?.id ?? '';
                          Get.toNamed("/ProductDetail")!.then((value) => justForYouProductController.getJustForYouProduct());
                        },
                        child: Container(
                          height: 120,
                          width: Get.width,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.tabBackground,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              1.width,
                              PreviewImageWidget(
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover,
                                image: products?.mainImage.toString(),
                                radius: 10,
                                errorWidget: Image.asset(
                                  AppAsset.categoryPlaceholder,
                                  height: 22,
                                ).paddingAll(20),
                                placeholder: Image.asset(
                                  AppAsset.categoryPlaceholder,
                                  height: 22,
                                ).paddingAll(20),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            products?.productName.toString().capitalizeFirst ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppFontStyle.styleW800(AppColors.white, 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    products?.productSaleType == 2 ? 0.height : 8.height,
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < (products?.attributes?.isNotEmpty == true ? (products?.attributes?[0].values?.length ?? 0) : 0); i++)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                              margin: const EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  products?.attributes?[0].values?[i].toUpperCase() ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(color: AppColors.unselected.withValues(alpha: 0.8), fontSize: 12),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    8.height,
                                    Text(
                                      "$currencySymbol ${products?.price}",
                                      style: AppFontStyle.styleW900(
                                        AppColors.primary,
                                        14,
                                      ),
                                    ),
                                    4.height,
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Color(0xffFACC15),
                                          size: 18,
                                        ),
                                        3.width,
                                        Text(
                                          products!.rating!.isEmpty ? St.noReviews.tr : "${products.rating?[0].avgRating}.0 (${products.rating?[0].totalUser})",
                                          style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                        ),
                                      ],
                                    )
                                  ],
                                ).paddingOnly(left: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      );
    });
  }
}

class HomePageShorts extends StatefulWidget {
  const HomePageShorts({super.key});

  @override
  State<HomePageShorts> createState() => _HomePageShortsState();
}

class _HomePageShortsState extends State<HomePageShorts> {
  GetReelsForUserController getReelsForUserController = Get.put(GetReelsForUserController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    getReelsForUserController.start = 1;
    // scrollController.addListener(() {
    //   _scrollListener();
    // });
    getReelsForUserController.allReels.clear();
    getReelsForUserController.getAllReels();
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {});
      getReelsForUserController.reelsPagination();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // getReelsForUserController.start = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppAsset.icShorts, width: 20),
              10.width,
              GeneralTitle(title: St.shorts.tr),
              Spacer(),
              GestureDetector(
                onTap: () {
                  final controller = Get.find<BottomBarController>();
                  controller.onChangeBottomBar(1);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    St.viewAll.tr,
                    style: AppFontStyle.styleW700(AppColors.primary, 15),
                  ),
                ),
              )
            ],
          ),
          12.height,
          SizedBox(
            height: 200,
            child: Obx(
              () => getReelsForUserController.isLoading.value
                  ? Shimmers.listViewShortHomePage()
                  : GetBuilder<GetReelsForUserController>(
                      builder: (GetReelsForUserController controller) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: getReelsForUserController.allReels.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // getReelsForUserController.pageController = PageController(initialPage: index);
                                // Get.offAll(const BottomBarView());
                                // final controller = Get.put(BottomBarController());
                                // controller.onChangeBottomBar(1);
                                final controller = Get.find<BottomBarController>();
                                controller.onChangeBottomBar(1, reelsIndex: index);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: PreviewImageWidget(
                                      color: AppColors.tabBackground,
                                      height: 200,
                                      width: 140,
                                      radius: 20,
                                      fit: BoxFit.cover,
                                      image: getReelsForUserController.allReels[index].thumbnail,
                                      placeholder: Image.asset(
                                        AppAsset.shortsPlaceholder,
                                        height: 22,
                                      ),
                                      errorWidget: Image.asset(
                                        AppAsset.shortsPlaceholder,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 44,
                                    width: 44,
                                    padding: EdgeInsets.only(left: 2),
                                    decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 30,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

// Future<String?> generateVideoThumbnail(String videoUrl) async {
//   try {
//     return await VideoThumbnail.thumbnailFile(
//         video: videoUrl,
//         thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.JPEG,
//         maxHeight: 500,
//         maxWidth: 220,
//         quality: 100);
//   } catch (e) {
//     print("Error generating thumbnail: $e");
//     return ''; // Return an empty string or a default thumbnail path
//   }
// }
}
