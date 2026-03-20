import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/custom_share.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/controller/preview_seller_profile_controller.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/widget/store_product_tab_bar_widget.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/widget/store_product_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PreviewSellerProfileView extends StatefulWidget {
  const PreviewSellerProfileView({super.key, required this.sellerId, required this.sellerName});

  final String sellerId;
  final String sellerName;

  @override
  State<PreviewSellerProfileView> createState() => _PreviewSellerProfileViewState();
}

class _PreviewSellerProfileViewState extends State<PreviewSellerProfileView> with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;

  double get expandedHeight {
    return _currentTabIndex == 0 ? 446.0 : 372.0;
  }

  void _onTabChanged(int index) {
    print("Tab changed to: $index"); // Debug print
    if (mounted) {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreviewSellerProfileController());
    controller.sellerId = widget.sellerId;

    Future<void> onClickShare() async {
      Get.dialog(LoadingUi(), barrierDismissible: false); // Start Loading...

      await BranchIoServices.onCreateBranchIoLink(
        id: controller.sellerId,
        sellerName: widget.sellerName,
        pageRoutes: "SellerProfile",
      );

      final link = await BranchIoServices.onGenerateLink();

      Get.back(); // Stop Loading...

      if (link != null) {
        CustomShare.onShareLink(link: link);
      }
    }

    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(
            () => AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: controller.isTabBarPinned.value ? AppColors.black : AppColors.transparent,
              shadowColor: AppColors.transparent,
              surfaceTintColor: AppColors.transparent,
              flexibleSpace: SimpleAppBarWidget(
                title: widget.sellerName,
                onBackTap: () {
                  FetchSellerProfileApi.startPagination = 0;
                  Get.back();
                },
              ),
            ),
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (!didPop) {
              FetchSellerProfileApi.startPagination = 0;
              Get.back();
            }
          },
          child: GetBuilder<PreviewSellerProfileController>(
            id: "onGetSellerProfile",
            builder: (controller) => controller.isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                : DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                      controller: controller.scrollController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          Obx(
                            () => SliverAppBar(
                              expandedHeight: expandedHeight,
                              pinned: true,
                              floating: true,
                              foregroundColor: AppColors.transparent,
                              shadowColor: AppColors.transparent,
                              surfaceTintColor: AppColors.transparent,
                              backgroundColor: AppColors.transparent,
                              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: controller.isTabBarPinned.value ? AppColors.black : AppColors.transparent),
                              flexibleSpace: FlexibleSpaceBar(
                                background: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 68,
                                          width: 68,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.white),
                                          ),
                                          child: PreviewProfileImageWidget(
                                            size: 68,
                                            image: controller.fetchSellerProfileModel?.data?.image ?? "",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          15.height,
                                          Center(
                                            child: Text(
                                              controller.fetchSellerProfileModel?.data?.businessName ?? "",
                                              style: AppFontStyle.styleW700(AppColors.white, 14),
                                            ),
                                          ),
                                          5.height,
                                          Center(
                                            child: Text(
                                              controller.fetchSellerProfileModel?.data?.businessTag ?? "",
                                              style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                            ),
                                          ),
                                          16.height,
                                          SizedBox(
                                            height: 60,
                                            width: Get.width,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // logic.switchToTab(0);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          controller.getTotalProductsCount().toString(),
                                                          style: AppFontStyle.styleW500(AppColors.white, 18),
                                                        ),
                                                        Text(
                                                          St.products.tr,
                                                          style: AppFontStyle.styleW500(AppColors.unselected, 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  indent: 8,
                                                  endIndent: 12,
                                                  width: 0,
                                                  thickness: 2,
                                                  color: AppColors.lightGrey.withValues(alpha: 0.2),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // logic.switchToTab(1);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "${controller.reels.length}",
                                                          style: AppFontStyle.styleW500(AppColors.white, 18),
                                                        ),
                                                        Text(
                                                          St.reels.tr,
                                                          style: AppFontStyle.styleW500(AppColors.unselected, 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  indent: 8,
                                                  endIndent: 12,
                                                  width: 0,
                                                  thickness: 2,
                                                  color: AppColors.lightGrey.withValues(alpha: 0.2),
                                                ),
                                                GetBuilder<PreviewSellerProfileController>(
                                                    id: 'onGetSellerFollowers',
                                                    builder: (context) {
                                                      return Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "${controller.followersList.length}",
                                                                style: AppFontStyle.styleW500(AppColors.white, 18),
                                                              ),
                                                              Text(
                                                                St.followers.tr,
                                                                style: AppFontStyle.styleW500(AppColors.unselected, 16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                          15.height,
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GetBuilder<PreviewSellerProfileController>(
                                                  id: "onChangeFollowButton",
                                                  builder: (controller) => MainButtonWidget(
                                                    height: 50,
                                                    border: controller.isFollowing ? Border.all(color: AppColors.primary) : null,
                                                    color: controller.isFollowing ? AppColors.transparent : AppColors.primary,
                                                    callback: () {
                                                      if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                                                        displayToast(message: St.thisIsDemoUser.tr);
                                                      } else {
                                                        controller.onChangeFollowButton();
                                                      }
                                                    },
                                                    child: Text(
                                                      controller.isFollowing ? "Following" : St.follow.tr,
                                                      style: AppFontStyle.styleW700(controller.isFollowing ? AppColors.primary : AppColors.black, 14),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              15.width,
                                              CircleButtonWidget(
                                                size: 50,
                                                color: AppColors.white.withValues(alpha: 0.2),
                                                child: Image.asset(AppAsset.icShare_1, width: 20),
                                                callback: () {
                                                  onClickShare();
                                                },
                                              ),
                                            ],
                                          ),
                                          25.height,
                                          DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.25)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(_currentTabIndex == 0 ? 114 : 56),
                                child: StoreProductTabBarWidget(
                                  onTabChanged: _onTabChanged,
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: GetBuilder<PreviewSellerProfileController>(
                        builder: (controller) {
                          print("-------------- ${controller.selectedMainTabIndex}");

                          return controller.selectedMainTabIndex == 0
                              ? StoreProductWidget()
                              : controller.selectedMainTabIndex == 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: sellerReelsView(),
                                    )
                                  : Padding(padding: EdgeInsets.only(top: 20), child: sellerFollowersList());
                        },
                      ),
                      // TabBarView(
                      //   children: [
                      // StoreProductWidget(),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20),
                      //   child: sellerReelsView(),
                      // ),
                      // Padding(padding: EdgeInsets.only(top: 20), child: sellerFollowersList()),
                      // ],
                      // ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
