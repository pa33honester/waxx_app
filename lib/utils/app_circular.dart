import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenCircular {
  static Container blackScreenCircular() {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppColors.black.withValues(alpha: .7),
      child: Center(
          child: CircularProgressIndicator(
        color: AppColors.primary,
      )),
    );
  }
}
