import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/custom/preview_profile_image_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/CoustomWidget/Page_devided/home_page_divided.dart';
import '../../../../utils/all_images.dart';
import '../../../../utils/globle_veriables.dart';

class FakeLiveSelling extends StatefulWidget {
  final String? videoUrl;
  final String? image;
  final String? name;
  final String? businessName;
  final String? view;

  const FakeLiveSelling({Key? key, this.videoUrl, this.image, this.name, this.businessName, this.view}) : super(key: key);

  @override
  State<FakeLiveSelling> createState() => _FakeLiveSellingState();
}

class _FakeLiveSellingState extends State<FakeLiveSelling> {
  bool isLiked = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse("${widget.videoUrl}"));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Stack(
                    children: [
                      CachedNetworkImage(
                        height: Get.height,
                        width: Get.width,
                        fit: BoxFit.cover,
                        imageUrl: "${widget.image}",
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      ),
                      BlurryContainer(
                        height: Get.height,
                        width: Get.width,
                        color: AppColors.black.withValues(alpha: 0.60),
                        blur: 4, child: const SizedBox(),
                        // decoration: BoxDecoration(color: AppColors.black.withValues(alpha:0.80)),
                      ),
                      const Center(child: CircularProgressIndicator())
                    ],
                  );
                }
              },
            ),
            Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Row(
                  children: [
                    15.width,
                    BlurryContainer(
                      height: 45,
                      width: 130,
                      blur: 100,
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
                          5.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFontStyle.styleW700(AppColors.white, 13),
                                ),
                                Text(
                                  "${widget.businessName}",
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
                      blur: 100,
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
                    15.width,
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: BlurryContainer(
                        height: 40,
                        width: 40,
                        blur: 100,
                        color: AppColors.white.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(50),
                        child: Center(child: Image.asset(AppAsset.icClose, color: AppColors.white, width: 15)),
                      ),
                    ),
                    15.width,
                  ],
                ),
                Container(
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
                                  controller: TextEditingController(),
                                  style: AppFontStyle.styleW500(AppColors.white, 15),
                                  decoration: InputDecoration(
                                    hintText: St.writeHere.tr,
                                    hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
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
                      10.width,
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(AppAsset.icCartFill, width: 22),
                        ),
                      ),
                      10.width,
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(AppAsset.icLiked, width: 25),
                        ),
                      ),
                      10.width,
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  child: SizedBox(
                    height: Get.height / 2,
                    width: Get.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: Get.width / 2,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const CommentListTileWidget(
                                title: "Loriel Andy",
                                subTitle: "How about yesterday's product,is it still available?",
                                image: "https://media.istockphoto.com/id/1414910820/photo/product-development-launching-analysis-and-market-validation-mvp-minimum-viable-product.jpg?s=612x612&w=0&k=20&c=7p9lovA8M8ZJQ7RHETKFeymxWNj_fKrxcn_sPRUU9JU=",
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    barrierColor: Colors.transparent,
                                    isScrollControlled: true,
                                    Container(
                                      height: Get.height / 1.5,
                                      decoration: BoxDecoration(color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff), borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                                      child: Stack(
                                        children: [
                                          const SingleChildScrollView(physics: BouncingScrollPhysics(), child: HomepageJustForYou(isShowTitle: false)).paddingOnly(top: 60),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              height: 62,
                                              decoration: BoxDecoration(color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff), borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SmallTitle(title: St.liveSelling.tr),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 5),
                                                        child: Obx(
                                                          () => Image(
                                                            image: isDark.value ? AssetImage(AppImage.lightcart) : AssetImage(AppImage.darkcart),
                                                            height: 22,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).paddingOnly(top: 18, bottom: 6),
                                                  Obx(
                                                    () => Divider(
                                                      color: isDark.value ? AppColors.white : AppColors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).paddingSymmetric(horizontal: 12),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: BlurryContainer(
                                  height: 49,
                                  width: 49,
                                  blur: 4.5,
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(50),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image(image: AssetImage(AppImage.redCart)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 49,
                                width: Get.width / 1.7,
                                child: TextFormField(
                                  maxLines: null,
                                  // style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                  decoration: InputDecoration(
                                      filled: true,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image(image: AssetImage(AppImage.sendMessage)),
                                      ),
                                      hintText: St.writeHere.tr,
                                      fillColor: const Color(0xffF6F8FE),
                                      hintStyle: const TextStyle(color: Color(0xff9CA4AB), fontSize: 13),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  isLiked = !isLiked;
                                },
                                child: Container(
                                  height: 49,
                                  width: 49,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF6F8FE),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Image(
                                      image: isLiked ? AssetImage(AppImage.productDislike) : AssetImage(AppImage.productLike),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List justForYouImage = [
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (1).png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (2).png",
    "assets/Home_page_image/just_for_you/Group 1000003097.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
  ];
  List justForYouName = [
    "Kendow Premium T-shirt",
    "Bondera Premium T-shirt",
    "Degra Premium T-shirt",
    "Dress Rehia",
    "Kendow Premium T-shirt",
  ];
  List justForYouPrise = [
    "95",
    "95",
    "89",
    "85",
    "95",
  ];
}

class CommentListTileWidget extends StatelessWidget {
  const CommentListTileWidget({super.key, this.width, required this.title, required this.subTitle, required this.image});

  final double? width;
  final String title;
  final String subTitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.zero,
      color: AppColors.transparent,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleButtonWidget(
            size: 42,
            color: AppColors.transparent,
            padding: const EdgeInsets.all(1.5),
            border: Border.all(color: AppColors.white),
            child: PreviewProfileImageWidget(size: 40, image: image),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW700(AppColors.white, 12),
                ),
                Text(
                  subTitle,
                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
