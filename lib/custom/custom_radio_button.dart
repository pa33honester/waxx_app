import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({super.key, required this.size, required this.isSelect, this.callback});

  final double? size;
  final bool isSelect;
  final Callback? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelect ? AppColors.primary : AppColors.transparent,
          border: isSelect ? null : Border.all(color: AppColors.unselected),
        ),
        child: isSelect ? Icon(Icons.done_rounded, size: 15, color: AppColors.black) : null,
      ),
    );
  }
}
