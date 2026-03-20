import 'dart:io';

import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/widget/bottom_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomBarView extends StatelessWidget {
  const BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomBarController());
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Image.asset(AppAsset.imgColorBg, fit: BoxFit.cover),
          ),
          GetBuilder<BottomBarController>(
            id: "onChangeBottomBar",
            builder: (logic) {
              return PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logic.bottomBarPages.length,
                controller: logic.pageController,
                onPageChanged: (int index) => logic.onChangeBottomBar(index),
                itemBuilder: (context, index) => logic.bottomBarPages[logic.selectedTabIndex],
              );
            },
          ),
          const Positioned(
            bottom: 0,
            child: BottomBarUi(),
          ),
        ],
      ),
      // bottomNavigationBar: const BottomBarUi(),
    );
  }
}
