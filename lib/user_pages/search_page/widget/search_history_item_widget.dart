import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class SearchHistoryItemWidget extends StatelessWidget {
  const SearchHistoryItemWidget({super.key, required this.title, required this.callback, required this.onClose});

  final String title;
  final Callback callback;
  final Callback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: Colors.transparent,
        height: 40,
        width: Get.width,
        child: Row(
          children: [
            5.width,
            Image.asset(AppAsset.icHistory, width: 20, color: AppColors.unselected),
            10.width,
            Text(
              title,
              style: AppFontStyle.styleW500(AppColors.unselected, 14),
            ),

            /// TODO
            /// Era 2.0
            // const Spacer(),
            // GestureDetector(
            //   onTap: onClose,
            //   child: Container(
            //     height: 40,
            //     width: 40,
            //     color: AppColors.transparent,
            //     alignment: Alignment.center,
            //     child: Image.asset(AppAsset.icClose, color: AppColors.unselected, width: 10),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
