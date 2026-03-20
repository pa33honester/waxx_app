import 'dart:developer';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../../Controller/GetxController/user/get_reels_controller.dart';

class ShowShorts extends StatefulWidget {
  final String videoUrl;
  final String productName;
  final String productPrice;
  final String productImage;
  final String productId;
  final String reelId;
  final bool isLikeOrNot;
  final String productDescription;
  final List<dynamic> attributeArray;
  final String businessName;
  final int selectedIndex;
  final int likeCount;
  final int index;
  final int currentPageIndex;

  const ShowShorts(
      {Key? key,
      required this.videoUrl,
      required this.productName,
      required this.productPrice,
      required this.productImage,
      required this.productDescription,
      required this.attributeArray,
      required this.businessName,
      required this.productId,
      required this.reelId,
      required this.isLikeOrNot,
      required this.selectedIndex,
      required this.likeCount,
      required this.index,
      required this.currentPageIndex})
      : super(key: key);

  @override
  _ShowShortsState createState() => _ShowShortsState();
}

class _ShowShortsState extends State<ShowShorts> with TickerProviderStateMixin {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  late AnimationController _likeAnimationController;
  late AnimationController _musicRotateAnimationController;

  GetReelsForUserController getReelsForUserController = Get.put(GetReelsForUserController());

  RxBool isLike = false.obs;
  RxInt likeCount = 0.obs;
  RxBool isBuffering = false.obs;
  RxBool isVideoLoading = true.obs;

  RxBool isReelsPage = true.obs; // This is Use to Stop Auto Playing..
  Future<void> initializeVideoPlayer() async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

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

  RxBool isShowIcon = false.obs;
  RxBool isPlaying = true.obs;
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

  @override
  void initState() {
    initializeVideoPlayer();
    isLike(widget.isLikeOrNot);
    likeCount(widget.likeCount);

    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 185),
    );

    _musicRotateAnimationController = AnimationController(
      duration: const Duration(seconds: 5), // Adjust the duration as needed
      vsync: this,
    )..repeat();
    super.initState();
  }

  ///k
  //onInit(){
  // isLike(widget.isLikeOrNot);
  // likeCount(widget.likeCount);
  //
  // videoPlayerController = VideoPlayerController.network(widget.videoUrl)
  //   ..initialize().then((_) {
  //     setState(() {
  //       videoPlayerController.setLooping(true);
  //       videoPlayerController.play();
  //     });
  //   });
  //
  // _likeAnimationController = AnimationController(
  //   vsync: this,
  //   duration: const Duration(milliseconds: 185),
  // );
  //
  // _musicRotateAnimationController = AnimationController(
  //   duration: const Duration(seconds: 5), // Adjust the duration as needed
  //   vsync: this,
  // )..repeat();
  // }
  @override
  void dispose() {
    /// k
    // _likeAnimationController.dispose();
    // _musicRotateAnimationController.dispose();
    // videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          // AspectRatio(
          //   aspectRatio: videoPlayerController.value.aspectRatio,
          //   child: VideoPlayer(videoPlayerController),
          // ),
          // if (!videoPlayerController.value.isInitialized)
          //   const Align(
          //       alignment: Alignment.bottomCenter,
          //       child: LinearProgressIndicator(
          //         minHeight: 6,
          //       )),
          GestureDetector(
            onTap: onClickVideo,
            child: Container(
              color: AppColors.black,
              height: (Get.height - 65),
              width: Get.width,
              child: isVideoLoading.value
                  ? const CupertinoActivityIndicator()
                  : SizedBox.expand(
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
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                AppColors.black.withValues(alpha: 0.60),
              ],
            )),
          ),
          InkWell(
            onTap: () => videoPlayerController?.play(),
            onDoubleTap: () {
              isLike.isFalse
                  ? {
                      getReelsForUserController.likeAndDislikeByUser(reelId: widget.reelId),
                      getReelsForUserController.likeDislikes[widget.selectedIndex] = true,
                      likeCount.value = likeCount.value + 1,
                      getReelsForUserController.likeCounts[widget.selectedIndex] = likeCount.value,
                    }
                  : null;

              getReelsForUserController.showLikeIcon(true);
              _likeAnimationController.forward();
              isLike(true);
              Future.delayed(const Duration(milliseconds: 1000), () async {
                await _likeAnimationController.reverse();
                getReelsForUserController.showLikeIcon(false);
              });
            },
            child: Obx(
              () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (getReelsForUserController.showLikeIcon.value) ...{
                      AnimatedBuilder(
                        animation: _likeAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _likeAnimationController.value,
                            child: child,
                          );
                        },
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                    }
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlurryContainer(
                    height: 120,
                    width: Get.width / 1.47,
                    blur: 4.5,
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    // decoration: BoxDecoration(
                    //   color: AppColors.white.withValues(alpha:0.40),
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            height: 96,
                            width: 90,
                            fit: BoxFit.cover,
                            imageUrl: widget.productImage,
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(
                              animating: true,
                            )),
                            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                          ),
                        ).paddingOnly(left: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.productName,
                                  overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                              Text(
                                "${widget.attributeArray[0]["name"].toString().capitalizeFirst} ${widget.attributeArray[0]["value"].join(", ")}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(fontSize: 13.2),
                              ).paddingOnly(top: 6),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    "$currencySymbol${widget.productPrice}",
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      productId = widget.productId;
                                      Get.toNamed("/ProductDetail");
                                      videoPlayerController?.pause();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Buy Now",
                                          style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ).paddingSymmetric(vertical: 13, horizontal: 7),
                        )
                      ],
                    ),
                  ).paddingOnly(bottom: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 43,
                        width: 43,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("assets/Live_page_image/bgImage.jpg"), fit: BoxFit.cover)),
                      ).paddingOnly(right: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.businessName,
                                style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                              ).paddingOnly(bottom: 4, right: 7),
                              Image.asset(
                                "assets/profile_icons/seller done.png",
                                height: 18,
                              )
                            ],
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (getReelsForUserController.isTextExpanded.value) {
                                  getReelsForUserController.isTextExpanded(false);
                                } else {
                                  getReelsForUserController.isTextExpanded(true);
                                }
                              },
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: SizedBox(
                                  width: Get.width * 0.6,
                                  height: getReelsForUserController.isTextExpanded.value ? Get.height * 0.16 : 43,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Text(
                                      widget.productDescription,
                                      maxLines: getReelsForUserController.isTextExpanded.value ? null : 2,
                                      overflow: getReelsForUserController.isTextExpanded.value ? TextOverflow.visible : TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.white,
                                        height: 1.4,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(bottom: 10)
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: Get.height / 3.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            isLike.toggle();

                            log("Like count list :: ${getReelsForUserController.likeCounts}");
                            log("Like issss :: ${getReelsForUserController.likeCounts[widget.selectedIndex]}");

                            isLike.isTrue
                                ? {
                                    getReelsForUserController.likeDislikes[widget.selectedIndex] = true,
                                    likeCount.value = likeCount.value + 1,
                                    getReelsForUserController.likeCounts[widget.selectedIndex] = likeCount.value,
                                  }
                                : {
                                    getReelsForUserController.likeDislikes[widget.selectedIndex] = false,
                                    likeCount.value = likeCount.value - 1,
                                    getReelsForUserController.likeCounts[widget.selectedIndex] = likeCount.value,
                                  };

                            log("Like count list 11111 :: ${getReelsForUserController.likeCounts}");

                            // log("Selected index :: ${widget.selectedIndex}");
                            // log("Selected index like or not :: ${getReelsForUserController.getReelsForUser!.reels![widget.selectedIndex].isLike}");
                            // // setState(() {
                            // isLike.isTrue
                            //     ? getReelsForUserController
                            //         .getReelsForUser!.reels![widget.selectedIndex].isLike = false
                            //     : getReelsForUserController
                            //         .getReelsForUser!.reels![widget.selectedIndex].isLike = true;
                            // log("Selected index like or not final :: ${getReelsForUserController.getReelsForUser!.reels![widget.selectedIndex].isLike}");
                            // // });
                            getReelsForUserController.likeAndDislikeByUser(reelId: widget.reelId);
                          },
                          child: Obx(
                            () => Column(
                              children: [
                                Image.asset(
                                  "assets/icons/reels_favorite.png",
                                  height: 33,
                                  color: isLike.value ? Colors.red : AppColors.white,
                                ).paddingOnly(bottom: 4),
                                Text(
                                  "${likeCount.value}",
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white),
                                )
                              ],
                            ),
                          )),
                      // GestureDetector(
                      //     onTap: () {
                      //       Get.bottomSheet(
                      //         isScrollControlled: true,
                      //         reelsCommentBottomSheet(),
                      //       );
                      //     },
                      //     child: Image.asset("assets/icons/reels_messege.png", height: 33)),
                      GestureDetector(
                          onTap: () async {
                            var url = Uri.parse("https://play.google.com/store/apps/details?id=com.erashop.live");
                            if (await canLaunchUrl(url)) {
                              launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              throw "Cannot load the page";
                            }
                          },
                          child: Image.asset("assets/icons/reels_share.png", height: 33)),
                      AnimatedBuilder(
                        animation: _musicRotateAnimationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _musicRotateAnimationController.value * 2.0 * 3.14159265358979323846,
                            child: child,
                          );
                        },
                        child: Image.asset("assets/icons/reels_music.png", height: 36),
                      ),
                      // Image.asset("assets/icons/reels_music.png",
                      //     height: 34),
                      // now make me this widget rotate clock wise
                    ],
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 15),

          /// For preload shorts use package
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 15),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Obx(
          //       () => getReelsForUserController.moreLoading.value
          //           ? Container(
          //               height: 55,
          //               width: 55,
          //               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha:0.60)),
          //               child: const Center(
          //                 child: SizedBox(
          //                   height: 25,
          //                   width: 25,
          //                   child: CircularProgressIndicator(
          //                     strokeWidth: 3,
          //                   ),
          //                 ),
          //               ),
          //             )
          //           : const SizedBox.shrink(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
