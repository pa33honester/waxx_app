import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:chewie/chewie.dart';
import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/preview_profile_image_widget.dart';
import 'package:era_shop/user_pages/fake_live_page/controller/fake_live_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:video_player/video_player.dart';

import '../../../seller_pages/select_product_for_streame/model/selected_product_model.dart';

class FakeLiveView extends StatefulWidget {
  const FakeLiveView({super.key, this.videoUrl, this.image, this.title, this.subTitle, this.view, this.selectedProducts});

  final String? videoUrl;
  final String? image;
  final String? title;
  final String? subTitle;
  final String? view;
  final List<SelectedProduct>? selectedProducts;

  @override
  State<FakeLiveView> createState() => _FakeLiveViewState();
}

class _FakeLiveViewState extends State<FakeLiveView> {
  final controller = Get.put(FakeLiveController());
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    initializeVideoPlayer();
    super.initState();
  }

  Future<void> initializeVideoPlayer() async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl ?? ''));

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
        videoPlayerController?.play();
        controller.update(["initializeVideoPlayer"]);
      }
    } catch (e) {
      onDisposeVideoPlayer();
      Utils.showLog("Reels Video Initialization Failed !!! => $e");
    }
  }

  void onDisposeVideoPlayer() {
    try {
      videoPlayerController?.dispose();
      chewieController?.dispose();
      chewieController = null;
      videoPlayerController = null;
      controller.update(["initializeVideoPlayer"]);
    } catch (e) {
      Utils.showLog(">>>> On Dispose VideoPlayer Error => $e");
    }
  }

  @override
  void dispose() {
    onDisposeVideoPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FakeLiveController>(
        id: "initializeVideoPlayer",
        builder: (controller) {
          return Stack(
            children: [
              Container(
                color: AppColors.black,
                width: Get.width,
                height: Get.height,
                child: videoPlayerController?.value.isInitialized == true
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: videoPlayerController?.value.size.width ?? 0,
                            height: videoPlayerController?.value.size.height ?? 0,
                            child: chewieController != null ? VideoPlayer(videoPlayerController!) : CircularProgressIndicator(color: AppColors.unselected),
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator(color: AppColors.unselected)),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.transparent, AppColors.black.withValues(alpha: 0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: Get.height / 3,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.transparent, AppColors.black.withValues(alpha: 0.7)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).viewPadding.top + 10,
                child: SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      15.width,
                      BlurryContainer(
                        height: 45,
                        width: 150,
                        blur: 2,
                        padding: EdgeInsets.zero,
                        color: AppColors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            6.width,
                            CircleButtonWidget(
                              size: 35,
                              color: AppColors.transparent,
                              padding: const EdgeInsets.all(1.5),
                              border: Border.all(color: AppColors.white),
                              child: PreviewProfileImageWidget(size: 33, image: widget.image),
                            ),
                            8.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.subTitle}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFontStyle.styleW700(AppColors.white, 13),
                                  ),
                                  Text(
                                    "${widget.title}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFontStyle.styleW500(AppColors.white, 9),
                                  ),
                                ],
                              ),
                            ),
                            15.width,
                          ],
                        ),
                      ),
                      const Spacer(),
                      15.width,
                      BlurryContainer(
                        height: 40,
                        blur: 2,
                        color: AppColors.white.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            12.width,
                            Image.asset(AppAsset.icEye, width: 20),
                            5.width,
                            Text(
                              "${widget.view}k",
                              style: AppFontStyle.styleW700(AppColors.white, 12),
                            ),
                            10.width,
                            Container(
                              height: 26,
                              width: 45,
                              decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  St.liveText.tr,
                                  style: AppFontStyle.styleW700(AppColors.white, 12),
                                ),
                              ),
                            ),
                            8.width,
                          ],
                        ),
                      ),
                      // 14.width,
                      Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: BlurryContainer(
                          height: 40,
                          width: 40,
                          blur: 2,
                          color: AppColors.white.withValues(alpha: 0.1),
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(50),
                          child: Center(child: Image.asset(AppAsset.icClose, color: AppColors.white.withValues(alpha: 0.8), width: 13)),
                        ),
                      ),
                      10.width,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  // height: 50,
                  width: Get.width,
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.width,
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              15.width,
                              Expanded(
                                child: TextFormField(
                                  controller: controller.commentController,
                                  style: AppFontStyle.styleW500(AppColors.black, 15),
                                  decoration: InputDecoration(
                                    hintText: St.writeHere.tr,
                                    hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.onSendComment,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                                  padding: const EdgeInsets.only(right: 3),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.black,
                                  ),
                                  child: Image.asset(AppAsset.icSend, color: AppColors.white, width: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.width,
                      GetBuilder<FakeLiveController>(builder: (context) {
                        var selectedProduct = widget.selectedProducts?[0];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              productId = widget.selectedProducts?[0].productId ?? "";
                              Get.toNamed("/ProductDetail");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.white),
                                  ),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: PreviewImageWidget(
                                      height: 55,
                                      width: 55,
                                      fit: BoxFit.cover,
                                      image: selectedProduct?.mainImage ?? "",
                                      radius: 10,
                                    ),
                                  ),
                                ),
                                5.height,
                                Text(St.txtShop.tr, style: AppFontStyle.styleW500(AppColors.white, 12)),
                              ],
                            ),
                          ),
                        );
                      }).paddingOnly(right: 22),
                      /*    GestureDetector(
                        onTap: () => LiveSellingBottomSheet.onShow(),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(AppAsset.icCartFill, width: 22),
                              Positioned(
                                right: -5,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                    border: Border.all(color: AppColors.white),
                                  ),
                                  child: Text(
                                    "10",
                                    style: AppFontStyle.styleW700(AppColors.black, 7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.width,
                      GetBuilder<FakeLiveController>(
                        id: "onClickLike",
                        builder: (controller) => GestureDetector(
                          onTap: controller.onClickLike,
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(controller.isLike ? AppAsset.icLiked : AppAsset.icHeart, width: 25),
                          ),
                        ),
                      ),
                      10.width,*/
                    ],
                  ),
                ),
              ),
              /* Positioned(
                left: 10,
                // bottom: 70 + 135,
                bottom: 70,
                child: SizedBox(
                  height: Get.height / 3,
                  width: Get.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width / 2,
                          child: GetBuilder<FakeLiveController>(
                            id: "onUpdateComment",
                            builder: (controller) => Align(
                              alignment: Alignment.bottomCenter,
                              child: SingleChildScrollView(
                                controller: controller.scrollController,
                                child: ListView.builder(
                                  itemCount: controller.fakeComments.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final indexData = controller.fakeComments[index];
                                    return CommentListTileWidget(
                                      title: indexData.user,
                                      subTitle: indexData.message,
                                      image: indexData.image,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 84,
                          child: GetBuilder<FakeLiveController>(builder: (context) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.selectedProducts?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var selectedProduct = widget.selectedProducts?[0];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      productId = widget.selectedProducts?[index].id ?? "";
                                      Get.toNamed("/ProductDetail");
                                    },
                                    child: Container(
                                      height: 108,
                                      width: 85,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: CachedNetworkImage(
                                              height: 80,
                                              width: 75,
                                              fit: BoxFit.cover,
                                              imageUrl: selectedProduct?.mainImage.toString() ?? "",
                                              placeholder: (context, url) => const Center(
                                                  child: CupertinoActivityIndicator(
                                                animating: true,
                                              )),
                                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                            ),
                                          ),
                                          Text(
                                            "$currencySymbol${selectedProduct?.price}",
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 10.5, color: AppColors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ).paddingOnly(right: 22),
                      ],
                    ),
                  ),
                ),
              ),*/
              // Visibility(
              //   visible: true,
              //   child: Positioned(
              //     bottom: 65,
              //     left: 10,
              //     child: LiveSellProductWidget(
              //       title: "Devils Wears",
              //       description: "Kendow Premium T-shirt Most Popular",
              //       sizes: const ["S", "M", "XL", "XXL"],
              //       price: "560.00",
              //       image: "https://dermletter.com/wp-content/uploads/2024/04/Vitamin-C-Ascorbic-Acid-in-Skincare.jpg",
              //       callback: () {},
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class LiveSellProductWidget extends StatelessWidget {
  const LiveSellProductWidget({
    super.key,
    required this.title,
    required this.description,
    required this.sizes,
    required this.price,
    required this.image,
    required this.callback,
  });

  final String title;
  final String description;
  final String image;
  final List sizes;
  final String price;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: Get.width / 1.25,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreviewImageWidget(
            height: 105,
            width: 105,
            fit: BoxFit.cover,
            image: image,
            radius: 15,
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppFontStyle.styleW700(AppColors.black, 13),
                          ),
                          Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppFontStyle.styleW500(AppColors.unselected, 11),
                          ),
                        ],
                      ),
                    ),
                    CircleButtonWidget(
                      size: 30,
                      color: AppColors.transparent,
                      child: Image.asset(AppAsset.icClose, width: 12, color: AppColors.black),
                    ),
                    5.width,
                  ],
                ),
                5.height,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < sizes.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            sizes[i],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppFontStyle.styleW500(AppColors.unselected, 8),
                          ),
                        ),
                    ],
                  ),
                ),
                7.height,
                Row(
                  children: [
                    Text(
                      "$currencySymbol $price",
                      style: AppFontStyle.styleW900(AppColors.black, 16),
                    ),
                    const Spacer(),
                    MainButtonWidget(
                      color: AppColors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      borderRadius: 5,
                      child: Text(
                        St.buyNow.tr,
                        style: AppFontStyle.styleW700(AppColors.primary, 11),
                      ),
                    ),
                    3.width,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
