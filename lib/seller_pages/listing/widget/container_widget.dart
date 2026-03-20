import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({super.key, required this.child, required this.onTap});

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }
}

class ContainerDataWidget extends StatelessWidget {
  const ContainerDataWidget({super.key, required this.child, this.padding, required this.tap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final void Function()? tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        // height: 54,
        width: Get.width,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }
}
