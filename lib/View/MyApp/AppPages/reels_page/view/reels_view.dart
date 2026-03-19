import 'package:era_shop/View/MyApp/AppPages/reels_page/controller/reels_controller.dart';
import 'package:era_shop/View/MyApp/AppPages/reels_page/widget/reels_widget.dart';
import 'package:era_shop/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomBarController = Get.find<BottomBarController>();
    controller.init(initialIndex: bottomBarController.initialReelsIndex);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Get.find<BottomBarController>().onChangeBottomBar(0);
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: GetBuilder<ReelsController>(
          id: "onGetReels",
          builder: (controller) => controller.isLoadingReels
              ? Shimmers.reelsView()
              : controller.mainReels.isEmpty
                  ? Center(
                      child: noDataFound(
                        image: "assets/no_data_found/reels_not_found.png",
                        text: St.noShortFound.tr,
                      ),
                    )
                  : PreloadPageView.builder(
                      controller: controller.preloadPageController,
                      itemCount: controller.mainReels.length,
                      preloadPagesCount: 4,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (value) async {
                        controller.onPagination(value);
                        controller.onChangePage(value);
                      },
                      itemBuilder: (context, index) {
                        return GetBuilder<ReelsController>(
                          id: "onChangePage",
                          builder: (controller) => PreviewReelsView(
                            index: index,
                            currentPageIndex: controller.currentPageIndex,
                          ),
                        );
                      },
                    ),
        ),
        bottomNavigationBar: GetBuilder<ReelsController>(
          id: "onPagination",
          builder: (controller) => Visibility(
            visible: controller.isPaginationLoading,
            child: const LinearProgressIndicator(color: Colors.pink),
          ),
        ),
      ),
    );
  }
}
