import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:flutter/material.dart';

class PreviewImageWidget extends StatelessWidget {
  const PreviewImageWidget(
      {super.key,
      this.image,
      this.height,
      this.width,
      this.fit,
      this.color,
      this.radius,
      this.margin,
      this.placeholder,
      this.errorWidget,
      this.defaultHeight});

  final double? height;
  final double? width;
  final double? defaultHeight;
  final String? image;
  final BoxFit? fit;
  final Color? color;
  final double? radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: CachedNetworkImage(
        imageUrl: image ?? "",
        fit: fit,
        errorWidget: (context, url, error) => errorWidget ?? _defaultPlaceholder(),
        placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return Center(
        child: Image.asset(
      AppAsset.categoryPlaceholder,
      height: defaultHeight,
    ));
  }
}
