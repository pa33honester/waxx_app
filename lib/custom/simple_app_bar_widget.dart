import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleAppBarWidget extends StatelessWidget {
  const SimpleAppBarWidget({
    super.key,
    required this.title,
    this.onBackTap,
  });

  final String title;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onBackTap ?? () => Get.back(),
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
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                ),
              ),
              48.width,
            ],
          ),
        ),
      ),
    );
  }
}
