import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListingAppBarWidget extends StatelessWidget {
  const ListingAppBarWidget({
    super.key,
    required this.title,
    this.showCheckIcon = false,
    this.isCheckEnabled = false,
    this.onCheckTap,
  });

  final String? title;
  final bool showCheckIcon;
  final bool isCheckEnabled;
  final VoidCallback? onCheckTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.grayLight.withValues(alpha: 0.4),
      surfaceTintColor: AppColors.transparent,
      flexibleSpace: SafeArea(
        child: Container(
          color: AppColors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
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
                20.width,
                Expanded(
                  child: Text(
                    title ?? '',
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                ),
                if (showCheckIcon) ...[
                  GestureDetector(
                    onTap: isCheckEnabled ? onCheckTap : null,
                    child: Container(
                      height: 48,
                      width: 48,
                      alignment: Alignment.center,
                      // decoration: BoxDecoration(
                      //   color: isCheckEnabled ? AppColors.primary.withValues(alpha: 0.2) : AppColors.white.withValues(alpha: 0.2),
                      //   shape: BoxShape.circle,
                      // ),
                      child: Icon(
                        Icons.check,
                        color: isCheckEnabled ? AppColors.primary : AppColors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
