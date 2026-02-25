import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:flutter/material.dart';

class PreviewProfileImageWidget extends StatelessWidget {
  const PreviewProfileImageWidget({super.key, this.image, required this.size, this.fit, this.color});

  final double size;
  final String? image;
  final BoxFit? fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: CachedNetworkImage(
        imageUrl: image ?? "",
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
        errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
      ),
    );
  }
}
