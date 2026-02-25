import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({super.key, required this.title, required this.onTap, this.showCheckIcon = true});

  final String title;
  final void Function()? onTap;
  final bool showCheckIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCheckIcon)
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
          ),
        if (showCheckIcon) 16.width,
        Text(
          title,
          style: AppFontStyle.styleW900(AppColors.white, 16),
        ),
        Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.mode_edit_outline_outlined,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
