import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../ApiModel/seller/ShowUploadedReelsModel.dart';
import '../../../../Controller/GetxController/seller/manage_reels_controller.dart';

class ShortsPreview extends StatefulWidget {
  final String? videoUrl;

  /// For uploaded shorts
  final bool? ifUploadedReel;
  final String? productName;
  final String? productPrice;
  final String? productImage;
  final String? productDescription;
  final List<dynamic>? attributesArray;
  final List<ProductId>? productList;

  const ShortsPreview({super.key, this.videoUrl, this.ifUploadedReel, this.productName, this.productPrice, this.productImage, this.productDescription, this.attributesArray, this.productList});

  @override
  State<ShortsPreview> createState() => _ShortsPreviewState();
}

class _ShortsPreviewState extends State<ShortsPreview> {
  ManageShortsController manageShortsController = Get.put(ManageShortsController());
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _disposeVideoPlayer();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      VideoPlayerController videoCtrl;

      if (widget.ifUploadedReel == true) {
        // Network video: create a new controller
        videoCtrl = VideoPlayerController.networkUrl(Uri.parse("${widget.videoUrl}"));
      } else {
        // Local file: create a separate controller to avoid conflicts with CreateShort's widgets
        videoCtrl = VideoPlayerController.file(manageShortsController.reelVideo!);
      }
      await videoCtrl.initialize();
      videoCtrl.setLooping(true);

      _videoController = videoCtrl;

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Defer play() to after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            videoCtrl.play();
          }
        });
      }
    } catch (e) {
      debugPrint("Video initialization error: $e");
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = true;
        });
      }
    }
  }

  void _disposeVideoPlayer() {
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
            child: CircularProgressIndicator(
          color: AppColors.lightPrimary,
        )),
      );
    }
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Unable to load video preview.',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey,
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_videoController != null && _videoController!.value.isInitialized)
                  Positioned.fill(
                    child: VideoPlayer(_videoController!),
                  )
                else
                  Positioned.fill(
                    child: Container(color: Colors.black),
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
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    26.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        widget.ifUploadedReel == true
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : manageShortsController.uploadReels(widget.productDescription ?? "");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                    child: Text(
                                      St.upload.tr,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    const Spacer(),
                    BlurryContainer(
                      blur: 15,
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        "OUR BEST PRODUCT",
                        style: GoogleFonts.plusJakartaSans(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    15.height,
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: Get.height * .12,
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
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.ifUploadedReel == true ? widget.productList?.length : manageShortsController.selectedProducts.length,
                            itemBuilder: (context, index) {
                              final products = widget.ifUploadedReel == true ? widget.productList![index] : manageShortsController.selectedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: BlurryContainer(
                                  blur: 4.5,
                                  width: Get.width / 1.6,
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PreviewImageWidget(
                                        height: 75,
                                        width: 75,
                                        fit: BoxFit.cover,
                                        radius: 10,
                                        image: products.mainImage.toString(),
                                      ),
                                      8.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              products.productName.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              products.description.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.white.withValues(alpha: .7),
                                                fontSize: 10,
                                              ),
                                            ),
                                            // Text(
                                            //   "${St.size.tr} ${widget.ifUploadedReel == true ? widget.attributesArray![0]["value"].join(", ") : manageShortsController.attributesArray![0]["value"].join(", ")}",
                                            //   // "Size Change",
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: AppFontStyle.styleW400(Colors.grey, 13.2),
                                            // ).paddingOnly(top: 6),
                                            4.height,
                                            Row(
                                              children: [
                                                Text(
                                                  "$currencySymbol ${products.price}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW700(AppColors.primary, 15),
                                                ),
                                                8.width,
                                                GestureDetector(
                                                  onTap: () {
                                                    displayToast(message: St.thisIsOnlyPreview.tr);
                                                  },
                                                  child: Container(
                                                    // height: 25,
                                                    // width: 80,
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ).paddingOnly(bottom: 15),
                              ).paddingOnly(left: index == 0 ? 16 : 0);
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 43,
                          width: 43,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: sellerImageXFile == null ? Image.network(sellerEditImage, fit: BoxFit.cover) : Image.file(File(sellerImageXFile?.path ?? "")),
                        ).paddingOnly(right: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  editBusinessName,
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
                                  // if (manageShortsController.isTextExpanded.value) {
                                  //   manageShortsController.isTextExpanded(false);
                                  // } else {
                                  //   manageShortsController.isTextExpanded(true);
                                  // }
                                },
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: SizedBox(
                                    width: Get.width * 0.6,
                                    height: manageShortsController.isTextExpanded.value ? Get.height * 0.16 : 43,
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Text(
                                        widget.ifUploadedReel == true ? widget.productDescription ?? "" : manageShortsController.selectedProductDescription.text,
                                        maxLines: manageShortsController.isTextExpanded.value ? null : 2,
                                        overflow: manageShortsController.isTextExpanded.value ? TextOverflow.visible : TextOverflow.ellipsis,
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
                    ).paddingOnly(bottom: 23, left: 16, right: 16)
                  ],
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => manageShortsController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink(),
        )
      ],
    );
  }
}
