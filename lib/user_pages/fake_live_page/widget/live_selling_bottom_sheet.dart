import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class LiveSellingBottomSheet {
  static Future<void> onShow() async {
    await Get.bottomSheet(
      backgroundColor: AppColors.black,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            20.height,
            Center(
              child: Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            10.height,
            Row(
              children: [
                Text(
                  St.liveSelling.tr,
                  style: AppFontStyle.styleW900(AppColors.white, 18),
                ),
                const Spacer(),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(AppAsset.icCartFill, color: AppColors.white, width: 22),
                      Positioned(
                        right: -5,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(color: AppColors.white),
                          ),
                          child: Text(
                            "10",
                            style: AppFontStyle.styleW700(AppColors.black, 7),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            10.height,
            Divider(color: AppColors.unselected.withValues(alpha: 0.2)),
            20.height,
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return LiveSellingItemWidget(
                      title: "Devils Wears",
                      description: "Kendow Premium T-shirt Most Popular",
                      sizes: const ["S", "M", "XL", "XXL"],
                      price: "560.00",
                      image: "https://dermletter.com/wp-content/uploads/2024/04/Vitamin-C-Ascorbic-Acid-in-Skincare.jpg",
                      callback: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveSellingItemWidget extends StatelessWidget {
  const LiveSellingItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.sizes,
    required this.price,
    required this.image,
    required this.callback,
  });

  final String title;
  final String description;
  final String image;
  final List sizes;
  final String price;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.tabBackground.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreviewImageWidget(
            height: 105,
            width: 105,
            fit: BoxFit.cover,
            image: image,
            radius: 15,
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppFontStyle.styleW700(AppColors.white, 13),
                ),
                Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                ),
                5.height,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < sizes.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            sizes[i],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppFontStyle.styleW500(AppColors.unselected, 8),
                          ),
                        ),
                    ],
                  ),
                ),
                7.height,
                Text(
                  "$currencySymbol $price",
                  style: AppFontStyle.styleW900(AppColors.primary, 16),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MainButtonWidget(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                borderRadius: 5,
                child: Row(
                  children: [
                    Image.asset(AppAsset.icCart, color: AppColors.black, width: 15),
                    5.width,
                    Text(
                      "ADD CART",
                      style: AppFontStyle.styleW700(AppColors.black, 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          3.width,
        ],
      ),
    );
  }
}
