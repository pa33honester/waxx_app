import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralTitle extends StatelessWidget {
  const GeneralTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 16),
    );
  }
}

class SmallTitle extends StatelessWidget {
  final String title;
  const SmallTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppFontStyle.styleW700(AppColors.white, 14),
    );
  }
}
