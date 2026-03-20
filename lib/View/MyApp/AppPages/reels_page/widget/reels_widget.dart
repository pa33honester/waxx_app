import 'dart:convert';
import 'dart:developer';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:chewie/chewie.dart';
import 'package:waxxapp/Controller/GetxController/user/follow_unfollow_controller.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/api/reels_like_dislike_api.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/controller/reels_controller.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/custom_share.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

import '../../../../../ApiModel/seller/GetReelsForUserModel.dart';

class PreviewReelsView extends StatefulWidget {
  const PreviewReelsView({super.key, required this.index, required this.currentPageIndex});

  final int index;
  final int currentPageIndex;

  @override
  State<PreviewReelsView> createState() => _PreviewReelsViewState();
}

class _PreviewReelsViewState extends State<PreviewReelsView> with TickerProviderStateMixin {
  final controller = Get.find<ReelsController>();
  FollowUnFollowController followUnFollowController = Get.put(FollowUnFollowController());

  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  RxBool isPlaying = true.obs;
  RxBool isShowIcon = false.obs;

  RxBool isPreviewDetails = false.obs;

  RxBool isBuffering = false.obs;
  RxBool isVideoLoading = true.obs;

  RxBool isShowLikeAnimation = false.obs;
  RxBool isShowLikeIconAnimation = false.obs;

  RxBool isReelsPage = true.obs; // This is Use to Stop Auto Playing..

  RxBool isLike = false.obs;
  RxMap customChanges = {"like": 0, "comment": 0}.obs;

  AnimationController? _controller;
  late Animation<double> _animation;
  late AnimationController _likeAnimationController;

  bool isFollow = false;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 185),
    );

    if (_controller != null) {
      _animation = Tween(begin: 0.0, end: 1.0).animate(_controller!);
    }
    initializeVideoPlayer();
    customSetting();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    onDisposeVideoPlayer();
    log("Dispose Method Called Success");
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    try {
      String videoPath = controller.mainReels[widget.index].video ?? "";

      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoPath));

      await videoPlayerController?.initialize();

      if (videoPlayerController != null && (videoPlayerController?.value.isInitialized ?? false)) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          looping: true,
          allowedScreenSleep: false,
          allowMuting: false,
          showControlsOnInitialize: false,
          showControls: false,
          maxScale: 1,
        );

        if (chewieController != null) {
          isVideoLoading.value = false;
          (widget.index == widget.currentPageIndex && isReelsPage.value) ? onPlayVideo() : null; // Use => First Time Video Playing...
        } else {
          isVideoLoading.value = true;
        }

        videoPlayerController?.addListener(
          () {
            // Use => If Video Buffering then show loading....
            (videoPlayerController?.value.isBuffering ?? false) ? isBuffering.value = true : isBuffering.value = false;

            if (isReelsPage.value == false) {
              onStopVideo(); // Use => On Change Routes...
            }
          },
        );
      }
    } catch (e) {
      onDisposeVideoPlayer();
      log("Reels Video Initialization Failed !!! ${widget.index} => $e");
    }
  }

  void onStopVideo() {
    isPlaying.value = false;
    videoPlayerController?.pause();
  }

  void onPlayVideo() {
    isPlaying.value = true;
    videoPlayerController?.play();
  }

  void onDisposeVideoPlayer() {
    try {
      onStopVideo();
      videoPlayerController?.dispose();
      chewieController?.dispose();
      chewieController = null;
      videoPlayerController = null;
      isVideoLoading.value = true;
    } catch (e) {
      log(">>>> On Dispose VideoPlayer Error => $e");
    }
  }

  void customSetting() {
    isLike.value = controller.mainReels[widget.index].isLike!;
    customChanges["like"] = int.parse(controller.mainReels[widget.index].like.toString());
  }

  void onClickVideo() async {
    if (isVideoLoading.value == false) {
      videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
      isShowIcon.value = true;
      await 2.seconds.delay();
      isShowIcon.value = false;
    }
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  void onClickPlayPause() async {
    videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  Future<void> onClickShare() async {
    isReelsPage.value = false;

    Get.dialog(LoadingUi(), barrierDismissible: false); // Start Loading...

    await BranchIoServices.onCreateBranchIoLink(
      id: controller.mainReels[widget.index].id ?? "",
      sellerName: controller.mainReels[widget.index].sellerId?.businessName ?? "",
      pageRoutes: "Video",
    );

    final link = await BranchIoServices.onGenerateLink();

    Get.back(); // Stop Loading...

    if (link != null) {
      CustomShare.onShareLink(link: link);
    }
  }

  // Future<void> onClickShare() async {
  //   var url = Uri.parse("https://play.google.com/store/apps/details?id=com.erashop.live");
  //   if (await canLaunchUrl(url)) {
  //     launchUrl(url, mode: LaunchMode.externalApplication);
  //     throw "Cannot load the page";
  //   }
  // }

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
      videoId: controller.mainReels[widget.index].id!,
    );
  }

  Future<void> onDoubleClick() async {
    log("onDoubleClick:::::::::");
    if (isLike.value) {
      log("onDoubleClick:isShowLikeAnimation::::::::");
      _likeAnimationController.forward();
      isShowLikeAnimation.value = true;

      await 1200.milliseconds.delay();
      isShowLikeAnimation.value = false;
    } else {
      isLike.value = true;
      customChanges["like"]++;
      _likeAnimationController.forward();
      isShowLikeAnimation.value = true;
      Vibration.vibrate(duration: 50, amplitude: 128);
      await 1200.milliseconds.delay();
      isShowLikeAnimation.value = false;
      await ReelsLikeDislikeApi.callApi(
        loginUserId: loginUserId,
        videoId: controller.mainReels[widget.index].id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == widget.currentPageIndex) {
      // Use => Play Current Video On Scrolling...
      (isVideoLoading.value == false && isReelsPage.value) ? onPlayVideo() : null;
    } else {
      // Restart Previous Video On Scrolling...
      isVideoLoading.value == false ? videoPlayerController?.seekTo(Duration.zero) : null;
      onStopVideo(); // Stop Previous Video On Scrolling...
    }
    return Scaffold(
      body: Obx(
        () => isVideoLoading.value
            ? Shimmers.reelsView()
            : SizedBox(
                height: Get.height,
                width: Get.width,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: onClickVideo,
                      onDoubleTap: onDoubleClick,
                      child: Container(
                        color: Colors.black,
                        height: Get.height,
                        width: Get.width,
                        child: SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: videoPlayerController?.value.size.width ?? 0,
                              height: videoPlayerController?.value.size.height ?? 0,
                              child: Chewie(controller: chewieController!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => isShowIcon.value
                          ? Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: onClickPlayPause,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: EdgeInsets.only(left: isPlaying.value ? 0 : 2),
                                  decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                  child: Center(
                                      child: Icon(
                                    isPlaying.value ? Icons.pause : Icons.play_arrow,
                                    size: 30,
                                    color: AppColors.white,
                                  )
                                      //
                                      // Image.asset(
                                      //   isPlaying.value ? AppAsset.icPause : AppAsset.icPlay,
                                      //   width: 30,
                                      //   height: 30,
                                      //   color: AppColor.white,
                                      // ),
                                      ),
                                ),
                              ),
                            )
                          : const Offstage(),
                    ),
                    // Obx(
                    //   () => Center(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         if (isShowLikeAnimation.value) ...{
                    //           AnimatedBuilder(
                    //             animation: _likeAnimationController,
                    //             builder: (context, child) {
                    //               return Transform.scale(
                    //                 scale: _likeAnimationController.value,
                    //                 child: child,
                    //               );
                    //             },
                    //             child: const Icon(
                    //               Icons.favorite_rounded,
                    //               color: Colors.red,
                    //               size: 100,
                    //             ),
                    //           ),
                    //         }
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                    /* Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: Get.height,
                        width: 60,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleButtonWidget(
                              callback: onClickLike,
                              size: 42,
                              color: AppColors.black.withValues(alpha: 0.3),
                              child: isLike.value ? Image.asset(AppAsset.icHeart, color: AppColors.white, width: 22) : Image.asset(AppAsset.icLiked, width: 22),
                            ),
                            20.height,
                            CircleButtonWidget(
                              callback: onClickShare,
                              size: 42,
                              color: AppColors.black.withValues(alpha: 0.3),
                              child: Image.asset(AppAsset.icShare, width: 22),
                            ),
                            20.height,
                            CircleButtonWidget(
                              callback: () {
                                Get.bottomSheet(
                                  GetBuilder<ReelsController>(builder: (logic) {
                                    return Container(
                                      height: Get.height * 0.60,
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            St.reportThisProduct.tr,
                                            style: AppFontStyle.styleW700(AppColors.white, 18),
                                          ),
                                          14.height,
                                          Divider(),
                                          8.height,
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: logic.reportReasonModel?.data?.length,
                                              itemBuilder: (context, index) {
                                                final report = logic.reportReasonModel?.data?[index];
                                                final isSelected = logic.selectedReport?.id == report?.id;
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      logic.selectReportReason(report);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 22,
                                                          width: 22,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: AppColors.white, width: 1.5),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Container(
                                                            height: 12,
                                                            width: 12,
                                                            decoration: BoxDecoration(
                                                              color: isSelected ? AppColors.white : AppColors.black,
                                                              shape: BoxShape.circle,
                                                            ),
                                                          ),
                                                        ),
                                                        16.width,
                                                        Text(
                                                          logic.reportReasonModel?.data?[index].title ?? '',
                                                          style: AppFontStyle.styleW500(AppColors.white, 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          18.height,
                                          Row(
                                            children: [
                                              Expanded(
                                                child: MainButtonWidget(
                                                  height: 50,
                                                  width: Get.width,
                                                  color: AppColors.black,
                                                  border: Border.all(color: AppColors.primary),
                                                  callback: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    St.cancelText.tr,
                                                    style: AppFontStyle.styleW700(AppColors.primary, 16),
                                                  ),
                                                ),
                                              ),
                                              16.width,
                                              Expanded(
                                                child: MainButtonWidget(
                                                  height: 50,
                                                  width: Get.width,
                                                  color: AppColors.primary,
                                                  callback: () {
                                                    logic.reportReel(userId: loginUserId, reelId: controller.mainReels[widget.index].id ?? '', description: logic.selectedReport?.title ?? '');
                                                  },
                                                  child: Text(
                                                    St.report.tr,
                                                    style: AppFontStyle.styleW700(AppColors.black, 16),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                  isScrollControlled: true,
                                  backgroundColor: AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                );
                              },
                              size: 42,
                              color: AppColors.black.withValues(alpha: 0.3),
                              child: Icon(Icons.more_vert, color: AppColors.white, size: 22),
                            ),
                            120.height,
                          ],
                        ),
                      ),
                    ),*/
                    Positioned(
                      bottom: 100,
                      child: Container(
                        width: Get.width,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                        GestureDetector(
                                          onTap: () {
                                            isVideoLoading.value == false ? videoPlayerController?.seekTo(Duration.zero) : null;
                                            onStopVideo(); // Stop Previous Video On Scrolling...

                                            Get.to(
                                              PreviewSellerProfileView(
                                                sellerName: controller.mainReels[widget.index].sellerId?.businessName ?? "",
                                                sellerId: controller.mainReels[widget.index].sellerId?.id ?? "",
                                              ),
                                            )?.then(
                                              (value) {
                                                (isVideoLoading.value == false && isReelsPage.value) ? onPlayVideo() : null;
                                              },
                                            );
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
                                                  child: PreviewProfileImageWidget(
                                                    image: controller.mainReels[widget.index].sellerId?.image ?? '',
                                                    fit: BoxFit.cover,
                                                    size: 20,
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
                                                        Flexible(fit: FlexFit.loose, child: GeneralTitle(title: controller.mainReels[widget.index].sellerId?.businessName ?? "")),
                                                        10.width,
                                                        controller.mainReels[widget.index].sellerId?.id == sellerId
                                                            ? SizedBox()
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  setState(() {});
                                                                  isFollow = !isFollow;
                                                                  followUnFollowController.followUnfollowData(sellerId: controller.mainReels[widget.index].sellerId?.id.toString() ?? "");
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
                                        ),
                                        10.height,
                                        Text(
                                          controller.mainReels[widget.index].description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFontStyle.styleW500(
                                            AppColors.white,
                                            11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CircleButtonWidget(
                                        callback: onClickLike,
                                        size: 42,
                                        color: AppColors.black.withValues(alpha: 0.3),
                                        child: isLike.value ? Image.asset(AppAsset.icHeart, color: AppColors.white, width: 22) : Image.asset(AppAsset.icLiked, width: 22),
                                      ),
                                      20.height,
                                      CircleButtonWidget(
                                        callback: onClickShare,
                                        size: 42,
                                        color: AppColors.black.withValues(alpha: 0.3),
                                        child: Image.asset(AppAsset.icShare, width: 22),
                                      ),
                                      20.height,
                                      CircleButtonWidget(
                                        callback: () {
                                          Get.bottomSheet(
                                            GetBuilder<ReelsController>(builder: (logic) {
                                              return Container(
                                                height: Get.height * 0.60,
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      St.reportThisProduct.tr,
                                                      style: AppFontStyle.styleW700(AppColors.white, 18),
                                                    ),
                                                    14.height,
                                                    Divider(),
                                                    8.height,
                                                    Expanded(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: logic.reportReasonModel?.data?.length,
                                                        itemBuilder: (context, index) {
                                                          final report = logic.reportReasonModel?.data?[index];
                                                          final isSelected = logic.selectedReport?.id == report?.id;
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                logic.selectReportReason(report);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 22,
                                                                    width: 22,
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: AppColors.white, width: 1.5),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Container(
                                                                      height: 12,
                                                                      width: 12,
                                                                      decoration: BoxDecoration(
                                                                        color: isSelected ? AppColors.white : AppColors.black,
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  16.width,
                                                                  Text(
                                                                    logic.reportReasonModel?.data?[index].title ?? '',
                                                                    style: AppFontStyle.styleW500(AppColors.white, 14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    18.height,
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: MainButtonWidget(
                                                            height: 50,
                                                            width: Get.width,
                                                            color: AppColors.black,
                                                            border: Border.all(color: AppColors.primary),
                                                            callback: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              St.cancelText.tr,
                                                              style: AppFontStyle.styleW700(AppColors.primary, 16),
                                                            ),
                                                          ),
                                                        ),
                                                        16.width,
                                                        Expanded(
                                                          child: MainButtonWidget(
                                                            height: 50,
                                                            width: Get.width,
                                                            color: AppColors.primary,
                                                            callback: () {
                                                              logic.reportReel(userId: loginUserId, reelId: controller.mainReels[widget.index].id ?? '', description: logic.selectedReport?.title ?? '');
                                                            },
                                                            child: Text(
                                                              St.report.tr,
                                                              style: AppFontStyle.styleW700(AppColors.black, 16),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                            isScrollControlled: true,
                                            backgroundColor: AppColors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                          );
                                        },
                                        size: 42,
                                        color: AppColors.black.withValues(alpha: 0.3),
                                        child: Icon(Icons.more_vert, color: AppColors.white, size: 22),
                                      ),
                                      // 20.height,
                                    ],
                                  ),
                                )
                              ],
                            ),
                            15.height,
                            SizedBox(
                              height: Get.height * .10,
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.1, 0.9, 1.0],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.mainReels[widget.index].productId?.length,
                                  itemBuilder: (context, index) {
                                    final products = controller.mainReels[widget.index].productId?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        productId = products?.id ?? "";
                                        Get.toNamed("/ProductDetail");
                                        videoPlayerController?.pause();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: BlurryContainer(
                                          width: Get.width / 1.55,
                                          blur: 15,
                                          color: AppColors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(16),
                                          child: Row(
                                            children: [
                                              PreviewImageWidget(height: 75, width: 75, fit: BoxFit.cover, radius: 15, image: products?.mainImage),
                                              10.width,
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      products?.productName ?? "",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: AppFontStyle.styleW700(AppColors.white, 13),
                                                    ),
                                                    Text(
                                                      products?.description ?? "",
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color: AppColors.white.withValues(alpha: .7),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "$currencySymbol ${products?.price ?? ""}",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: AppFontStyle.styleW600(AppColors.primary, 15),
                                                        ),
                                                        5.width,
                                                        const Spacer(),
                                                        products?.seller == sellerId
                                                            ? SizedBox()
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  productId = products?.id ?? "";
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
                                      ),
                                    ).paddingOnly(left: index == 0 ? 16 : 0);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
