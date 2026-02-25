import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryItemUi extends StatelessWidget {
  const HistoryItemUi({
    super.key,
    required this.title,
    required this.date,
    required this.uniqueId,
    required this.coin,
    required this.reason,
    this.icon,
    this.iconColor,
    this.containerColor,
    this.titleColor,
  });

  final String title;
  final String date;
  final String uniqueId;
  final String coin;
  final String reason;
  final String? icon;
  final Color? iconColor;
  final Color? containerColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: reason == "" ? 70 : 80,
      width: Get.width,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.unselected.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.width,
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.unselected.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Image.asset(
                icon ?? AppAsset.icWallet,
                width: 32,
                color: iconColor,
              ),
            ),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppFontStyle.styleW700(titleColor, 13),
                ),
                Text(
                  date,
                  style: AppFontStyle.styleW500(AppColors.unselected, 10),
                ),
                2.height,
                Text(
                  "ID : $uniqueId",
                  style: AppFontStyle.styleW500(AppColors.unselected, 10),
                ),
                Visibility(
                  visible: reason != "",
                  child: SizedBox(
                    width: Get.width / 2,
                    child: Text(
                      "Reason : $reason",
                      maxLines: 1,
                      style: AppFontStyle.styleW500(AppColors.unselected, 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.width,
          Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                coin,
                style: AppFontStyle.styleW700(
                  titleColor ?? AppColors.red,
                  15,
                ),
              ),
            ),
          ),
          10.width,
        ],
      ),
    );
  }
}
