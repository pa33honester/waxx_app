import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class SearchAppBarWidget extends StatelessWidget {
  const SearchAppBarWidget({super.key, required this.controller, this.callback, required this.onChanged});

  final TextEditingController controller;
  final Callback? callback;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            5.width,
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected.withValues(alpha: 0.5)),
                    10.width,
                    Expanded(
                      child: TextFormField(
                        cursorColor: AppColors.unselected,
                        controller: controller,
                        textInputAction: TextInputAction.search,
                        style: AppFontStyle.styleW500(AppColors.white, 15),
                        decoration: InputDecoration(
                          hintText: St.searchText.tr,
                          hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 5),
                        ),
                        onChanged: onChanged,
                        // onFieldSubmitted: onChanged,
                      ),
                    ),
                    VerticalDivider(
                      color: AppColors.unselected.withValues(alpha: 0.5),
                      indent: 10,
                      endIndent: 10,
                    ),
                    GestureDetector(
                      onTap: callback,
                      child: Container(
                        height: 48,
                        width: 25,
                        alignment: Alignment.center,
                        color: AppColors.transparent,
                        child: Image.asset(AppAsset.icFilter, width: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
