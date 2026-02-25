import 'dart:developer';

import 'package:era_shop/Controller/GetxController/login/splash_screen_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  SplashScreenController splashScreenController = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();
    log("Init state called");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      log("App is in Background");
    }
    if (state == AppLifecycleState.resumed) {
      log("App is in Foreground");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPink,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Get.height / 3),
          Center(
              child: Text(
            St.appName.tr,
            style: AppFontStyle.styleW700(AppColors.black, 48),
          )),
          SizedBox(height: Get.height / 3),
          LoadingAnimationWidget.beat(color: AppColors.black, size: 50)
        ],
      ),
    );
  }
}
