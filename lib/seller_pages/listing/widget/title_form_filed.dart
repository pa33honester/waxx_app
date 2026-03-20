import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleFormFiled extends StatelessWidget {
  const TitleFormFiled({super.key, required this.controller, this.counterTextLength, this.maxLength, this.maxLines, this.hintText, this.keyboardType, this.inputFormatters, this.onChanged});

  final TextEditingController controller;
  final int? counterTextLength;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.unselected,
      style: AppFontStyle.styleW700(AppColors.white, 15),
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters ?? [],
      onFieldSubmitted: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.tabBackground,
        hintText: hintText,
        hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: .6), 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        counterText: (counterTextLength != null && maxLength != null) ? '$counterTextLength/$maxLength' : "",
        counterStyle: AppFontStyle.styleW500(AppColors.unselected, 12),
      ),
    );
  }
}
