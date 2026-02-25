import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class MainButtonWidget extends StatelessWidget {
  const MainButtonWidget({super.key, this.height, this.width, this.color, this.child, this.borderRadius, this.callback, this.padding, this.margin, this.border});

  final double? height;
  final double? width;
  final Color? color;
  final Widget? child;
  final double? borderRadius;
  final Callback? callback;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: padding,
        margin: margin,
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
