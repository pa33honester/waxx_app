import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/user_pages/popular_products_page/model/popular_product_model.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularProductItem extends StatelessWidget {
  final PopularProducts product;

  const PopularProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    print('---------------${product.rating}');
    return GestureDetector(
      onTap: () {
        productId = product.id ?? '';
        Get.toNamed("/ProductDetail");
      },
      child: Container(
        width: 170,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: product.mainImage.toString(),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          AppAsset.categoryPlaceholder,
                          height: 22,
                        ).paddingAll(40),
                        placeholder: (context, url) => Image.asset(
                          AppAsset.categoryPlaceholder,
                          height: 22,
                        ).paddingAll(40),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     // if (getStorage.read("isDemoLogin") ?? false) {
                            //     //   displayToast(message: St.thisIsDemoUser.tr);
                            //     //   return;
                            //     // } else {
                            //     //   galleryCategoryController.likes[index] = !galleryCategoryController.likes[index];
                            //     //   galleryCategoryController.update();
                            //     //
                            //     //   addToFavoriteController.postFavoriteData(productId: "${product.id}", categoryId: "${product.category!.id}");
                            //     // }
                            //   },
                            //   child: Container(
                            //     height: 30,
                            //     width: 30,
                            //     decoration: BoxDecoration(
                            //       color: AppColors.white,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       // child: Image(
                            //       //   image: product.isFavorite == true & galleryCategoryController.likes[index] ? AssetImage(AppAsset.icHeartFill) : AssetImage(AppAsset.icHeart),
                            //       //   color: product.isFavorite == true & galleryCategoryController.likes[index] ? AppColors.red : null,
                            //       // ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 11),
                  ),
                  2.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "$currencySymbol ${product.price}",
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW900(AppColors.primary, 15),
                      ),
                      Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xffFACC15),
                        size: 16,
                      ),
                      2.width,
                      Text(
                        product.rating!.isEmpty ? St.noReviews.tr : "${product.rating?[0].avgRating}.0",
                        style: AppFontStyle.styleW500(AppColors.unselected, 9),
                      ),
                    ],
                  ),
                  5.height,
                  Text(
                    "${product.productName}",
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.styleW600(AppColors.unselected, 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
