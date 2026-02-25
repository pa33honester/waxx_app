import 'package:dotted_border/dotted_border.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CircleDottedBorderWidget extends StatelessWidget {
  const CircleDottedBorderWidget({super.key, required this.size, required this.child, this.color, this.callback});

  final Widget child;
  final double size;
  final Color? color;
  final Callback? callback;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: CircularDottedBorderOptions(
        strokeWidth: 1,
        stackFit: StackFit.expand,
        color: AppColors.primary,
        padding: EdgeInsets.all(3),
      ),
      // stackFit: StackFit.expand,
      // borderType: BorderType.Circle,
      // color: AppColors.primary,
      // padding: const EdgeInsets.all(3),
      // strokeWidth: 1,
      child: child,
    );
  }
}
