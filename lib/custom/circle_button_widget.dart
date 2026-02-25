import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CircleButtonWidget extends StatelessWidget {
  const CircleButtonWidget({super.key, this.callback, required this.size, required this.color, this.child, this.padding, this.border});

  final Callback? callback;
  final double size;
  final Color color;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: size,
        width: size,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: border),
        child: child,
      ),
    );
  }
}
