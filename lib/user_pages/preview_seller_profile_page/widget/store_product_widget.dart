import 'dart:developer';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:waxxapp/ApiModel/seller/SellerReelsModel.dart';
import 'package:waxxapp/Controller/GetxController/user/follow_unfollow_controller.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/api/reels_like_dislike_api.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/custom_share.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/controller/preview_seller_profile_controller.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/model/fetch_seller_profile_model.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class StoreProductWidget extends StatelessWidget {
  const StoreProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreviewSellerProfileController>(
      id: "onGetSellerProfile",
      builder: (controller) => Container(
        color: AppColors.black,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: controller.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  final indexData = controller.products[index];
                  return GestureDetector(
                    onTap: () {
                      productId = indexData.id ?? '';
                      Get.toNamed("/ProductDetail");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: indexData.mainImage ?? " ",
                                      errorWidget: (context, url, error) => Image.asset(
                                        AppAsset.categoryPlaceholder,
                                        height: 22,
                                      ).paddingAll(36),
                                      placeholder: (context, url) => Image.asset(
                                        AppAsset.categoryPlaceholder,
                                        height: 22,
                                      ).paddingAll(36),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          CircleButtonWidget(
                                            size: 30,
                                            color: AppColors.white,
                                            child: controller.products[index].isFavorite == true ? Image.asset(AppAsset.icHeartFill, width: 16, color: AppColors.red) : Image.asset(AppAsset.icHeart, width: 16, color: AppColors.black),
                                            callback: () => controller.onClickFavoriteProduct(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  indexData.productName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 11),
                                ),
                                2.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$currencySymbol ${indexData.price ?? "0.0"}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w900, fontFamily: AppConstant.appFontRegular, color: AppColors.primary, fontSize: 15),
                                    ),

                                    /// TODO /// Era 2.0
                                    ///
                                    // 5.width,
                                    // Text(
                                    //   "$currencySymbol 550.00",
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.w900,
                                    //     decoration: TextDecoration.lineThrough,
                                    //     fontFamily: AppConstant.appFontRegular,
                                    //     color: AppColors.unselected,
                                    //     fontSize: 10,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                2.height,
                                Text(
                                  indexData.description ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontFamily: AppConstant.appFontRegular, color: AppColors.unselected, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}

class CategoryTabsWidget extends StatelessWidget {
  const CategoryTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreviewSellerProfileController>(
      id: "onGetSellerProfile",
      builder: (controller) {
        if (controller.productsByCategory.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
          color: AppColors.black,
          child: TabBar(
            controller: controller.categoryTabController,
            physics: const BouncingScrollPhysics(),
            onTap: (value) {
              controller.onChangeTab(value);
            },
            indicator: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            isScrollable: true,
            unselectedLabelColor: AppColors.white,
            dividerColor: AppColors.transparent,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.only(right: 10),
            indicatorPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: controller.productsByCategory.asMap().entries.map<Tab>(
              (entry) {
                int index = entry.key;
                ProductsByCategory category = entry.value;
                bool isSelected = controller.selectedTabIndex == index;

                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      category.categoryName?.capitalizeFirst ?? "",
                      style: AppFontStyle.styleW700(
                        isSelected ? AppColors.black : AppColors.unselected,
                        13,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ).paddingSymmetric(vertical: 5),
        );
      },
    );
  }
}

GetBuilder<PreviewSellerProfileController> sellerReelsView() {
  return GetBuilder<PreviewSellerProfileController>(
    id: "onGetSellerReels",
    builder: (controller) => controller.reels.isEmpty || controller.reels == []
        ? noDataFound(
            image: "assets/no_data_found/basket.png",
          )
        : GridView.builder(
            itemCount: controller.reels.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 250,
            ),
            itemBuilder: (context, index) {
              final indexData = controller.reels[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenReelView(reels: controller.reels, initialIndex: index, profile: controller.fetchSellerProfileModel?.data?.image ?? ''),
                    ),
                  );
                  // Re-fetch so the like count reflects any like the user
                  // just toggled inside the full-screen viewer.
                  controller.onGetSellerReels();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  imageUrl: indexData.thumbnail ?? "",
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Image.asset(
                                    AppAsset.categoryPlaceholder,
                                    height: 22,
                                  ).paddingAll(26),
                                  placeholder: (context, url) => Image.asset(
                                    AppAsset.categoryPlaceholder,
                                    height: 22,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Row(
                                  children: [
                                    Image.asset(AppAsset.icHeartFill, width: 16, color: AppColors.white).paddingOnly(right: 5),
                                    Text(
                                      (controller.reels[index].like ?? 0).toString(),
                                      style: AppFontStyle.styleW700(AppColors.white, 14),
                                    ),
                                    // Comment icon + count intentionally hidden:
                                    // there is no reel-comment system on the backend
                                    // (no model, route, or controller). Restore when
                                    // the feature ships.
                                  ],
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
          ),
  );
}

GetBuilder<PreviewSellerProfileController> sellerFollowersList() {
  return GetBuilder<PreviewSellerProfileController>(
    id: 'onGetSellerFollowers',
    builder: (controller) {
      return controller.followersList.isEmpty || controller.followersList == []
          ? noDataFound(
              image: "assets/no_data_found/basket.png",
            )
          : ListView.builder(
              itemCount: controller.followersList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleButtonWidget(
                            size: 46,
                            color: AppColors.white,
                            child: PreviewProfileImageWidget(
                              size: 44,
                              image: controller.followersList[index].userId?.image,
                            ),
                          ),
                          15.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.followersList[index].userId?.firstName}",
                                style: AppFontStyle.styleW700(AppColors.white, 14),
                              ),
                              5.height,
                              Text(
                                "${controller.followersList[index].userId?.lastName}",
                                style: AppFontStyle.styleW500(AppColors.unselected, 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.tabBackground.withValues(alpha: 0.7),
                      height: 5,
                      thickness: 0.5,
                    )
                  ],
                );
              },
            );
    },
  );
}

class FullScreenReelView extends StatefulWidget {
  final List<Reel> reels;
  final int initialIndex;
  final String profile;

  const FullScreenReelView({
    super.key,
    required this.reels,
    required this.initialIndex,
    required this.profile,
  });

  @override
  State<FullScreenReelView> createState() => _FullScreenReelViewState();
}

class _FullScreenReelViewState extends State<FullScreenReelView> {
  late PageController _pageController;
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;
  int _currentIndex = 0;
  final controller = Get.find<PreviewSellerProfileController>();
  bool isFollow = false;
  RxBool isLike = false.obs;
  RxMap customChanges = {"like": 0, "comment": 0}.obs;

  RxBool isShowLikeAnimation = false.obs;
  RxBool isShowLikeIconAnimation = false.obs;

  FollowUnFollowController followUnFollowController = Get.find();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideo(widget.reels[_currentIndex].video ?? "");
  }

  void _initializeVideo(String videoUrl) async {
    videoPlayerController = VideoPlayerController.network(videoUrl);
    await videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      // Hide default controls including play/pause
      allowFullScreen: false,
    );

    setState(() {});
  }

  Future<void> onClickShare() async {
    final reel = widget.reels[_currentIndex];
    final sellerName = reel.sellerId?.businessName ?? "";
    final context = sellerName.isNotEmpty
        ? "Check out $sellerName's video on Waxxapp"
        : "Check out this video on Waxxapp";
    final reelId = reel.id ?? "";
    final link = reelId.isNotEmpty ? "https://www.waxxapp.com/short/$reelId" : null;
    await CustomShare.onShareApp(context: context, link: link);
  }

  Future<void> onClickLike() async {
    log("onClickLike:::::::::");
    if (isLike.value) {
      isLike.value = false;
      customChanges["like"]--;
    } else {
      isLike.value = true;
      customChanges["like"]++;
    }

    isShowLikeIconAnimation.value = true;
    await 500.milliseconds.delay();
    isShowLikeIconAnimation.value = false;

    await ReelsLikeDislikeApi.callApi(
      loginUserId: loginUserId,
      videoId: controller.reels[widget.initialIndex].id!,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.reels.length,
        onPageChanged: (index) {
          videoPlayerController.pause();
          _chewieController.dispose();
          videoPlayerController.dispose();

          setState(() {
            _currentIndex = index;
            _initializeVideo(widget.reels[index].video ?? "");
          });
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              if (videoPlayerController.value.isInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoPlayerController.value.size.width,
                      height: videoPlayerController.value.size.height,
                      child: Chewie(controller: _chewieController),
                    ),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 0,
                child: Container(
                  height: Get.height / 4,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: Get.height,
                  width: 60,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() => CircleButtonWidget(
                            callback: onClickLike,
                            size: 42,
                            color: AppColors.black.withValues(alpha: 0.3),
                            child: isLike.value ? Image.asset(AppAsset.icHeart, color: AppColors.white, width: 22) : Image.asset(AppAsset.icLiked, width: 22),
                          )),
                      20.height,
                      CircleButtonWidget(
                        callback: onClickShare,
                        size: 42,
                        color: AppColors.black.withValues(alpha: 0.3),
                        child: Image.asset(AppAsset.icShare, width: 22),
                      ),
                      20.height,

                      /// TODO
                      /// Era 2.0
                      // CircleButtonWidget(
                      //   size: 42,
                      //   color: AppColors.black.withValues(alpha:0.3),
                      //   child: Image.asset(AppAsset.icExpand, width: 22),
                      // ),
                      // 20.height,
                      // CircleButtonWidget(
                      //   size: 42,
                      //   color: AppColors.black.withValues(alpha:0.3),
                      //   child: Image.asset(AppAsset.icMute, width: 22),
                      // ),
                      // 20.height,
                      // CircleButtonWidget(
                      //   size: 42,
                      //   color: AppColors.black.withValues(alpha:0.3),
                      //   child: Image.asset(AppAsset.icMore, width: 22),
                      // ),
                      50.height,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: Get.width / 1.2,
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlurryContainer(
                        blur: 15,
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.white.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          "OUR BEST PRODUCT",
                          style: AppFontStyle.styleW700(
                            AppColors.primary,
                            12,
                          ),
                        ),
                      ),
                      15.height,
                      BlurryContainer(
                        height: 96,
                        width: Get.width / 1.45,
                        blur: 15,
                        color: AppColors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            PreviewImageWidget(height: 75, width: 75, fit: BoxFit.cover, radius: 15, image: controller.reels[widget.initialIndex].productId?.mainImage),
                            10.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.reels[widget.initialIndex].productId?.productName ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFontStyle.styleW700(AppColors.white, 13),
                                  ),
                                  Text(
                                    controller.reels[widget.initialIndex].productId?.description ?? "",
                                    maxLines: 2,
                                    style: AppFontStyle.styleW400(
                                      AppColors.white.withValues(alpha: .7),
                                      10,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$currencySymbol ${controller.reels[widget.initialIndex].productId?.price ?? ""}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.styleW500(AppColors.primary, 15),
                                      ),
                                      5.width,
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          productId = controller.reels[widget.initialIndex].productId?.id ?? "";
                                          Get.toNamed("/ProductDetail");
                                          videoPlayerController?.pause();
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              St.buyNow.tr,
                                              style: AppFontStyle.styleW800(AppColors.black, 11.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      Row(
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
                              child: Image.network(
                                widget.profile ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(fit: FlexFit.loose, child: GeneralTitle(title: "")),
                                    10.width,
                                    GestureDetector(
                                      onTap: () {
                                        print('mmmmmmmmmmmm');
                                        setState(() {});
                                        isFollow = !isFollow;
                                        followUnFollowController.followUnfollowData(sellerId: controller.reels[widget.initialIndex].sellerId?.id.toString() ?? "");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: AppColors.black.withValues(alpha: 0.7),
                                        ),
                                        child: Text(
                                          isFollow ? St.unFollow.tr : St.follow.tr,
                                          style: AppFontStyle.styleW700(
                                            AppColors.white,
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  St.exploreTheLatestLiveDeals.tr,
                                  style: AppFontStyle.styleW500(
                                    AppColors.white,
                                    12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      Text(
                        controller.reels[widget.initialIndex].productId?.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW500(
                          AppColors.white,
                          11,
                        ),
                      ),
                      10.height,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
