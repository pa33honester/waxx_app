import 'package:waxxapp/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomColorBgWidget extends StatelessWidget {
  const CustomColorBgWidget({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(AppAsset.imgColorBg), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
