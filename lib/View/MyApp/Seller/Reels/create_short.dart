import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:waxxapp/View/MyApp/Seller/Reels/shorts_preview.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../ApiModel/seller/ShowUploadedReelsModel.dart';
import '../../../../Controller/GetxController/seller/manage_reels_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/text_titles.dart';
import '../../../../utils/CoustomWidget/App_theme_services/textfields.dart';
import '../../../../utils/app_asset.dart';

class CreateShort extends StatelessWidget {
  final ManageShortsController manageShortsController = Get.put(ManageShortsController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (manageShortsController.videoPlayerController != null) {
          await manageShortsController.videoPlayerController?.pause();
          await manageShortsController.videoPlayerController?.dispose();
          manageShortsController.videoPlayerController = null;
        }
        manageShortsController.reelsXFiles = null;
        manageShortsController.selectProductName.clear();
        manageShortsController.selectedProductDescription.clear();
      },
      child: Scaffold(
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
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (manageShortsController.videoPlayerController != null) {
                          await manageShortsController.videoPlayerController?.pause();
                          await manageShortsController.videoPlayerController?.dispose();
                          manageShortsController.videoPlayerController = null;
                        }
                        manageShortsController.reelsXFiles = null;
                        manageShortsController.selectProductName.clear();
                        manageShortsController.selectedProductDescription.clear();
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
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
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GeneralTitle(title: St.uploadShorts.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<ManageShortsController>(
                  builder: (ManageShortsController manageShortsController) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            St.uploadProductVideo.tr,
                            style: AppFontStyle.styleW600(AppColors.white, 16),
                          ),
                          4.height,
                          Text(
                            St.pleaseUploadClearAndHighQualityImages.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 11),
                          ),
                          20.height,
                          manageShortsController.isReelLoading
                              ? Container(
                                  width: Get.height * 0.190,
                                  height: Get.height * 0.240,
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  ),
                                )
                              : manageShortsController.reelsXFiles == null
                                  ? GestureDetector(
                                      onTap: () {
                                        manageShortsController.reelsPickFromGallery();
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.height * 0.190,
                                            height: Get.height * 0.240,
                                            child: GestureDetector(
                                              child: DottedBorder(
                                                options: RoundedRectDottedBorderOptions(
                                                  strokeWidth: 1,
                                                  dashPattern: [3, 3],
                                                  color: AppColors.unselected,
                                                  padding: EdgeInsets.all(14),
                                                  radius: Radius.circular(8),
                                                ),
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(13),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          AppAsset.icUpload,
                                                          width: 51,
                                                          height: 48,
                                                        ),
                                                        Text(
                                                          St.uploadVideo.tr,
                                                          style: TextStyle(color: AppColors.unselected, fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // child: Container(
                                      //   height: 400,
                                      //   width: double.maxFinite,
                                      //   decoration: BoxDecoration(
                                      //     color: AppColors.tabBackground,
                                      //     borderRadius: BorderRadius.circular(20),
                                      //   ),
                                      //   child: Column(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //       Image.asset(
                                      //         "assets/icons/add_image.png",
                                      //         height: 30.2,
                                      //         color: AppColors.unselected,
                                      //       ),
                                      //       Padding(
                                      //         padding: const EdgeInsets.only(top: 20),
                                      //         child: Text(
                                      //           St.selectVideoFromGallery.tr,
                                      //           style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ).paddingSymmetric(horizontal: 16),
                                    )
                                  : manageShortsController.videoPlayerController == null || !manageShortsController.videoPlayerController!.value.isInitialized
                                      ? Container(
                                          width: Get.height * 0.190,
                                          height: Get.height * 0.240,
                                          decoration: BoxDecoration(
                                            color: AppColors.tabBackground,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                      onTap: () {
                                        if (manageShortsController.videoPlayerController!.value.isPlaying) {
                                          manageShortsController.videoPlayerController!.pause();
                                        } else {
                                          manageShortsController.videoPlayerController!.play();
                                        }
                                      },
                                      child: Container(
                                        width: Get.height * 0.190,
                                        height: Get.height * 0.240,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Positioned.fill(
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: SizedBox(
                                                  width: manageShortsController.videoPlayerController!.value.size.width,
                                                  height: manageShortsController.videoPlayerController!.value.size.height,
                                                  child: Chewie(
                                                    controller: ChewieController(
                                                      videoPlayerController: manageShortsController.videoPlayerController!,
                                                      aspectRatio: manageShortsController.videoPlayerController!.value.aspectRatio,
                                                      showControls: false,
                                                      autoPlay: true,
                                                      autoInitialize: true,
                                                      looping: true,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: ValueListenableBuilder<VideoPlayerValue>(
                                                valueListenable: manageShortsController.videoPlayerController!,
                                                builder: (context, value, child) {
                                                  return Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding: EdgeInsets.only(left: value.isPlaying ? 0 : 2),
                                                    decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                                    child: Center(
                                                      child: Icon(
                                                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                        size: 30,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                manageShortsController.removeVideo();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4, right: 6),
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 3, left: 3),
                                                  height: 24,
                                                  width: 24,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white, width: 1),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                        ],
                      ),
                    );
                  },
                ),
                GetBuilder<ManageShortsController>(builder: (context) {
                  if (manageShortsController.selectedProductIds.isNotEmpty) {
                    return const SizedBox.shrink();
                  }
                  return PrimaryTextField(
                    titleText: St.selectedRelatedProduct.tr,
                    hintText: St.tapToSelectProduct.tr,
                    controllerType: "ReelsSelectProduct",
                  ).paddingSymmetric(horizontal: 16);
                }),
                const SizedBox(height: 14),
                GetBuilder<ManageShortsController>(
                  builder: (manageShortsController) {
                    if (manageShortsController.selectedProductIds.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${St.selectedRelatedProduct.tr} (${manageShortsController.selectedProductIds.length})",
                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/SelectProductWhenCreateReels");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.primary),
                                child: Text(
                                  St.change.tr,
                                  style: AppFontStyle.styleW600(AppColors.black, 12),
                                ),
                              ),
                            )
                            // GestureDetector(
                            //   onTap: () {
                            //     // manageShortsController.clearSelections();
                            //   },
                            //   child: Text(
                            //     "Clear All",
                            //     style: AppFontStyle.styleW500(AppColors.primary, 12),
                            //   ),
                            // ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        const SizedBox(height: 12),
                        GetBuilder<ManageShortsController>(
                          builder: (manageShortsController) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 96,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: manageShortsController.selectedProducts.length,
                                    itemBuilder: (context, index) {
                                      final ProductId product = manageShortsController.selectedProducts[index];
                                      return Container(
                                        width: Get.width / 1.6,
                                        margin: const EdgeInsets.only(right: 10),
                                        // color: AppColors.tabBackground,
                                        decoration: BoxDecoration(color: AppColors.tabBackground, borderRadius: BorderRadius.circular(12)),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    // alignment: Alignment.topRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          height: 80,
                                                          width: 80,
                                                          fit: BoxFit.cover,
                                                          imageUrl: product.mainImage ?? '',
                                                          placeholder: (context, url) => Container(
                                                            height: 80,
                                                            width: 80,
                                                            color: AppColors.tabBackground,
                                                            child: const Icon(Icons.image, color: Colors.grey),
                                                          ),
                                                          errorWidget: (context, url, error) => Container(
                                                            height: 80,
                                                            width: 80,
                                                            color: AppColors.tabBackground,
                                                            child: const Icon(Icons.error, color: Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          manageShortsController.removeProductFromSelection(manageShortsController.selectedIndices[index], manageShortsController.selectedProductIds[index]);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 3, left: 3),
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Colors.white, width: 1),
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 12,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  10.width,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          product.productName ?? 'Product',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700),
                                                        ),
                                                        // 4.height,
                                                        Text(
                                                          product.description.toString(),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: AppColors.white.withValues(alpha: .7),
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                        4.height,
                                                        Text(
                                                          "$currencySymbol ${product.price}",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: AppFontStyle.styleW700(AppColors.primary, 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).paddingOnly(left: index == 0 ? 16 : 0);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                      ],
                    );
                  },
                ),
                8.height,
                Row(
                  children: [
                    Text(
                      St.productDescriptionAIAssisted.tr,
                      style: AppFontStyle.styleW500(AppColors.white, 14),
                    ),
                    6.width,
                    Spacer(),
                    Obx(
                      () => Switch(
                        value: manageShortsController.isAutoGenerateOn.value,
                        onChanged: (value) {
                          manageShortsController.toggleAutoGenerate(value);
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.unselected,
                        inactiveTrackColor: AppColors.unselected.withValues(alpha: .45),
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 16),
                8.height,
                GetBuilder<ManageShortsController>(
                    id: AppConstant.idAutoReelDes,
                    builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: manageShortsController.selectedProductDescription,
                              maxLines: 15,
                              minLines: 6,
                              cursorColor: Colors.white,
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.tabBackground,
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                hintText: St.addDescriptionAboutYourProduct.tr,
                                hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                              // onChanged: (value) async {
                              //   if (manageShortsController.isAutoGenerateOn.value) {
                              //     await Future.delayed(const Duration(milliseconds: 1500));
                              //     if (manageShortsController.isAutoGenerateOn.value) {
                              //       manageShortsController.generateDescription();
                              //     }
                              //   }
                              //   manageShortsController.update();
                              // },
                            ),
                          ),
                          if (manageShortsController.isAutoGenerateOn.value) ...{
                            10.width,
                            Obx(
                              () {
                                return manageShortsController.isLoading.value && manageShortsController.isAutoGenerateOn.value
                                    ? SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (manageShortsController.isAutoGenerateOn.value) {
                                            await Future.delayed(const Duration(milliseconds: 1500));
                                            if (manageShortsController.isAutoGenerateOn.value) {
                                              manageShortsController.generateDescription();
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.refresh,
                                          color: AppColors.unselected,
                                          size: 28,
                                        ),
                                      );
                              },
                            ),
                          },
                        ],
                      ).paddingSymmetric(horizontal: 16);
                    }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: PrimaryPinkButton(
              onTaped: () {
                if (manageShortsController.reelsXFiles == null) {
                  displayToast(message: St.selectAVideoToProceed.tr);
                } else if (manageShortsController.selectedProductIds.isEmpty) {
                  displayToast(message: St.selectAProductToProceed.tr);
                } else if (manageShortsController.selectedProductDescription.text.isEmpty) {
                  displayToast(message: St.selectADescriptionToProceed.tr);
                } else {
                  // Dispose the video controller before navigating to avoid Android ExoPlayer conflicts
                  manageShortsController.videoPlayerController?.dispose();
                  manageShortsController.videoPlayerController = null;
                  Get.to(
                      () => ShortsPreview(
                            productDescription: manageShortsController.selectedProductDescription.text,
                          ),
                      transition: Transition.rightToLeft)?.then((_) async {
                    // Reinitialize video controller when returning from preview
                    if (manageShortsController.reelVideo != null) {
                      manageShortsController.videoPlayerController = VideoPlayerController.file(manageShortsController.reelVideo!);
                      await manageShortsController.videoPlayerController!.initialize();
                      manageShortsController.update();
                    }
                  });
                }
                // manageShortsController.reelsXFiles == null
                //     ? displayToast(message: St.selectAVideoToProceed.tr)
                //     : manageShortsController.selectProductName.text.isEmpty
                //         ? displayToast(message: St.selectAProductToProceed.tr)
                //         : manageShortsController.selectedProductDescription.text.isEmpty
                //             ? displayToast(message: St.selectADescriptionToProceed.tr)
                //             : Get.to(
                //                 () => ShortsPreview(
                //                       productDescription: manageShortsController.selectedProductDescription.text,
                //                     ),
                //                 transition: Transition.rightToLeft);
              },
              text: St.preview.tr),
        ),
      ),
    );
  }
}
