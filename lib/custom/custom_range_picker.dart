import 'package:era_shop/custom/show_date_picker.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/material.dart';

class CustomRangePicker {
  static Future<DateTimeRange?> onShow(BuildContext context) async {
    return await showRangePickerDialog(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      context: context,
      slidersColor: AppColors.white,
      maxDate: DateTime.now(),
      initialDate: DateTime.now(),
      minDate: DateTime(1900, 1, 1),
      barrierColor: AppColors.black.withValues(alpha: 0.8),
      enabledCellsTextStyle: AppFontStyle.styleW500(AppColors.white, 16),
      disabledCellsTextStyle: AppFontStyle.styleW500(AppColors.coloGreyText, 16),
      singleSelectedCellTextStyle: AppFontStyle.styleW500(AppColors.black, 14),
      singleSelectedCellDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      currentDateTextStyle: AppFontStyle.styleW500(AppColors.white, 16),
      currentDateDecoration: BoxDecoration(color: AppColors.unselected, shape: BoxShape.circle),
      daysOfTheWeekTextStyle: AppFontStyle.styleW500(AppColors.white.withValues(alpha: 0.6), 14),
      leadingDateTextStyle: AppFontStyle.styleW500(AppColors.white, 20),
      centerLeadingDate: true,
    );
  }
}
