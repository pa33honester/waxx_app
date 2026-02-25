import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/circle_icon_button_ui.dart';
import 'package:era_shop/custom/custom_share.dart';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/preview_profile_image_widget.dart';
import 'package:era_shop/seller_pages/live_page/controller/live_controller.dart';
import 'package:era_shop/seller_pages/live_page/widget/flip_profile_animation_widget.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/branch_io_services.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/socket_services.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/database.dart';
import '../bottom_sheet/product_list_bottom_sheet_ui.dart';

class LiveUi extends StatelessWidget {
  const LiveUi({
    super.key,
    required this.liveScreen,
    required this.isHost,
    this.liveRoomId,
    this.liveUserId,
    required this.isLoading,
    required this.liveUserImage,
  });

  final Widget liveScreen;
  final bool isHost;
  final String? liveRoomId;
  final String? liveUserId;
  final String? liveUserImage;
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isHost) {
          ExitLiveDialogUi.onShow(
            callBack: () {
              Get.close(3);
            },
          );
          return false;
        } else {
          Get.back();
          return false;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() => isLoading.value
              ? Stack(
                  children: [
                    SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: PreviewImageWidget(
                        image: liveUserImage,
                        height: Get.height,
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          color: Colors.grey.withValues(alpha: 0.1),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const Center(child: LoadingUi())
                  ],
                )
              : liveScreen),

          // Bottom gradient overlay
          _buildBottomGradient(),

          // Top bar
          _buildTopBar(context),

          // // Comments text field and products
          _buildCommentsTextFieldAndProducts(),
        ],
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 400,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.transparent, AppColors.black.withValues(alpha: 0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: isHost ? 45 : 40,
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: isHost ? _buildHostTopBar() : _buildUserTopBar(context),
        ),
      ),
    );
  }

  Widget _buildHostTopBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // View count
            Container(
              height: 30,
              width: 76,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAsset.icEye, width: 20),
                  8.width,
                  Obx(
                    () {
                      log(" Live Watch Count ${SocketServices.liveWatchCount.value}");
                      return Text(
                        CustomFormatNumber.convert(SocketServices.liveWatchCount.value),
                        maxLines: 1,
                        style: AppFontStyle.styleW700(AppColors.white, 12),
                      );
                    },
                  ),
                ],
              ),
            ),
            GetBuilder<LiveController>(
              init: LiveController(),
              id: "onChangeTime",
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAsset.icClock,
                    width: 22,
                    color: AppColors.white,
                  ),
                  8.width,
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 35),
                    child: Text(
                      controller.onConvertSecondToHMS(controller.countTime),
                      style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            // Close button
            CircleIconButtonUi(
              color: AppColors.black.withValues(alpha: 0.5),
              icon: AppAsset.icClose,
              iconColor: AppColors.white,
              circleSize: 35,
              iconSize: 14,
              callback: () {
                ExitLiveDialogUi.onShow(
                  callBack: () {
                    Get.close(3);
                  },
                );
              },
            ),
          ],
        ),
        20.height,
        // (Host quick controls removed in your code – leaving as-is)
        ..._buildHostControls(),
      ],
    );
  }

  List<Widget> _buildHostControls() {
    return [];
  }

  Widget _buildUserTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Host profile section
        GetBuilder<LiveController>(
          builder: (controller) => GestureDetector(
            child: Container(
              height: 50,
              width: 178,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(56),
                border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.3)),
                color: AppColors.black.withValues(alpha: 0.45),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    _buildHostAvatar(controller),
                    5.width,
                    _buildHostInfo(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
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
                SocketServices.liveWatchCount.value.toString(),
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
        CircleIconButtonUi(
          color: AppColors.black.withValues(alpha: 0.5),
          icon: AppAsset.icClose,
          iconColor: AppColors.white,
          circleSize: 36,
          iconSize: 14,
          callback: () {
            Get.close(1);
          },
        ),
      ],
    );
  }

  Widget _buildHostAvatar(LiveController controller) {
    return Container(
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(AppAsset.profilePlaceholder),
          ),
          PreviewProfileImageWidget(
            image: controller.image,
            size: 80,
          ),
          if (controller.isProfileImageBanned)
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: BlurryContainer(
                  blur: 3,
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.black.withValues(alpha: 0.3),
                  child: const Offstage(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHostInfo(LiveController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          controller.businessName.isNotEmpty ? controller.businessName : controller.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppFontStyle.styleW600(AppColors.white, 12),
        ),
        Stack(
          children: [
            Positioned(
              left: -10,
              child: Lottie.asset(
                AppAsset.lottieWaveAnimation,
                fit: BoxFit.cover,
                height: 20,
                width: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 2.5),
              child: SizedBox(
                width: 60,
                child: Text(
                  controller.businessTag.isNotEmpty ? controller.businessTag : controller.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW500(AppColors.white, 9),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentsTextFieldAndProducts() {
    return Positioned(
      left: 12,
      bottom: 15,
      right: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentsSection(),
          GetBuilder<LiveController>(
            builder: (controller) {
              return SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(visible: controller.liveType == 1, child: Expanded(child: _buildBottomInput().paddingOnly(right: 10))),
                    Visibility(
                      visible: controller.liveSelectedProducts.isNotEmpty,
                      child: _buildShopViewSection(),
                    )
                  ],
                ),
              );
            },
          ),
          12.height,
        ],
      ),
    );
  }

  Widget _buildShopViewSection() {
    return GetBuilder<LiveController>(
      builder: (controller) {
        log("controller.products.length: ${controller.liveSelectedProducts.length}");
        return GestureDetector(
          onTap: () {
            ProductListBottomSheetUi.show(context: Get.context!, isHost: true);
          },
          child: Column(
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
                    image: controller.liveSelectedProducts.first.mainImage ?? "",
                    radius: 10,
                  ),
                ),
              ),
              5.height,
              Text(St.txtShop.tr, style: AppFontStyle.styleW500(AppColors.white, 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection() {
    return SizedBox(
      height: 200,
      width: Get.width * 0.6,
      child: Obx(
        () => ScrollFadeEffectWidget(
          axis: Axis.vertical,
          child: SingleChildScrollView(
            controller: SocketServices.scrollController,
            child: ListView.builder(
              itemCount: SocketServices.mainLiveComments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                try {
                  final rawData = SocketServices.mainLiveComments[index];

                  Map<String, dynamic> data;
                  if (rawData is String) {
                    data = json.decode(rawData);
                  } else if (rawData is Map<String, dynamic>) {
                    data = rawData;
                  } else {
                    log("Unexpected data type: ${rawData.runtimeType}");
                    return const SizedBox.shrink();
                  }

                  return CommentItemUi(
                    title: data["userName"] ?? St.unknownUser.tr,
                    subTitle: data["commentText"] ?? data["comment"] ?? St.noComment.tr,
                    leading: data["userImage"] ?? "",
                  );
                } catch (e) {
                  log("Error parsing comment data at index $index: $e");
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInput() {
    return Row(
      children: [
        Expanded(
          child: isHost ? _buildHostInput() : _buildUserInput(),
        ),
      ],
    );
  }

  Widget _buildHostInput() {
    return GetBuilder<LiveController>(
      builder: (controller) => CommentTextFieldUi(
        controller: controller.commentController,
        callback: () => controller.onSendComment(),
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: GetBuilder<LiveController>(
            builder: (controller) => CommentTextFieldUi(
              controller: controller.commentController,
              callback: () => controller.onSendComment(),
            ),
          ),
        ),
        15.width,
      ],
    );
  }

  Future<void> _handleShare(LiveController controller) async {
    Get.dialog(const LoadingUi(), barrierDismissible: false);

    final link = await BranchIoServices.onGenerateLink();
    Get.back();

    if (link != null) {
      CustomShare.onShareLink(link: link);
    }
  }
}

// Existing UI components remain the same
class CommentTextFieldUi extends StatelessWidget {
  const CommentTextFieldUi({
    super.key,
    this.callback,
    this.controller,
  });

  final Callback? callback;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 15, right: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            5.width,
            Expanded(
              child: TextFormField(
                controller: controller,
                cursorColor: AppColors.coloGreyText,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  hintText: St.txtTypeComment.tr,
                  hintStyle: AppFontStyle.styleW400(AppColors.coloGreyText, 15),
                ),
              ),
            ),
            GestureDetector(
              onTap: callback,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black,
                ),
                child: Center(
                  child: Image.asset(width: 20, AppAsset.icSend, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentItemUi extends StatelessWidget {
  const CommentItemUi({
    super.key,
    required this.title,
    required this.subTitle,
    required this.leading,
  });

  final String title;
  final String subTitle;
  final String leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipOval(
          child: CachedNetworkImage(imageUrl: leading, width: 32, height: 32, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppFontStyle.styleW700(
                    AppColors.primary,
                    11.5,
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(0, 1), blurRadius: 1)],
                  )),
              Text(
                subTitle,
                style: AppFontStyle.styleW500(
                  Colors.white,
                  12.5,
                  shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(0, 1), blurRadius: 1)],
                ),
              )
            ],
          ),
        )
        // Expanded(
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: "$title ",
        //           style: AppFontStyle.styleW700(
        //             AppColors.primary,
        //             12,
        //             shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(0, 1), blurRadius: 1)],
        //           ),
        //         ),
        //         TextSpan(
        //           text: subTitle,
        //           style: AppFontStyle.styleW500(
        //             Colors.white,
        //             13,
        //             shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(0, 1), blurRadius: 1)],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

// Exit dialog with localized strings
class ExitLiveDialogUi {
  static Future<void> onShow({required Callback callBack}) async {
    Get.dialog(
      barrierColor: AppColors.black.withValues(alpha: 0.9),
      Dialog(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Container(
          width: 310,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(45),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 170,
                  width: 310,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  child: Image.asset(AppAsset.imgLive, width: 140),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.height,
                      Text(
                        St.exitTitleLine1.tr, // "Are You Exit In"
                        style: AppFontStyle.styleW700(AppColors.red, 16),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.exitTitleLine2.tr, // "Live Streaming"
                        style: AppFontStyle.styleW900(AppColors.red, 26),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.exitDescription.tr,
                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                      ),
                      20.height,
                      GestureDetector(
                        onTap: callBack,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.red,
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(St.exitLiveStreaming.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.unselected.withValues(alpha: 0.2),
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(St.cancelText.tr.capitalizeFirst.toString(), style: AppFontStyle.styleW700(AppColors.unselected, 16)),
                              ],
                            ),
                          ),
                        ),
                      ).paddingOnly(bottom: 15),
                    ],
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

class ScrollFadeEffectWidget extends StatelessWidget {
  const ScrollFadeEffectWidget({super.key, required this.child, required this.axis});

  final Widget child;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: axis == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: axis == Axis.horizontal ? Alignment.centerRight : Alignment.bottomCenter,
          colors: [
            axis == Axis.horizontal ? Colors.white : Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: const [0.0, 0.1, 0.9, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
