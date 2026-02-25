import 'package:era_shop/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class BottomBarUi extends StatelessWidget {
  const BottomBarUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(
      id: "onChangeBottomBar",
      builder: (logic) {
        return Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: logic.selectedTabIndex == 1 ? AppColors.transparent : AppColors.black,
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            height: AppConstant.bottomBarSize.toDouble(),
            width: Get.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _BottomBarIconUi(
                  icon: logic.selectedTabIndex == 0 ? AppAsset.icHomeFill : AppAsset.icHome,
                  callback: () => logic.onChangeBottomBar(0),
                  size: 22,
                  isSelect: logic.selectedTabIndex == 0,
                ),
                _BottomBarIconUi(
                  icon: logic.selectedTabIndex == 1 ? AppAsset.icReelsFill : AppAsset.icReels,
                  callback: () => logic.onChangeBottomBar(1),
                  size: 17,
                  isSelect: logic.selectedTabIndex == 1,
                ),
                _BottomBarIconUi(
                  icon: logic.selectedTabIndex == 2 ? AppAsset.icCartFill : AppAsset.icCart,
                  callback: () => logic.onChangeBottomBar(2),
                  size: 22,
                  isSelect: logic.selectedTabIndex == 2,
                ),
                _BottomBarIconUi(
                  icon: logic.selectedTabIndex == 3 ? AppAsset.icHeartFill : AppAsset.icHeart,
                  callback: () => logic.onChangeBottomBar(3),
                  size: 22,
                  isSelect: logic.selectedTabIndex == 3,
                ),
                _BottomBarIconUi(
                  icon: logic.selectedTabIndex == 4 ? AppAsset.icProfileFill : AppAsset.icProfile,
                  callback: () => logic.onChangeBottomBar(4),
                  size: 17,
                  isSelect: logic.selectedTabIndex == 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomBarIconUi extends StatelessWidget {
  const _BottomBarIconUi({required this.icon, required this.callback, required this.size, required this.isSelect});

  final String icon;
  final double size;
  final Callback callback;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: callback,
        child: Container(
          height: 48,
          width: 48,
          color: AppColors.transparent,
          child: Container(
              decoration: BoxDecoration(color: isSelect ? AppColors.primary : AppColors.transparent, shape: BoxShape.circle),
              child: Center(child: Image.asset(icon, width: size))),
        ),
      ),
    );
  }
}
