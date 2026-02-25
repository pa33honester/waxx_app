import 'package:era_shop/custom/custom_radio_button.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/user_pages/my_order_page/widget/give_review_bottom_sheet.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class RateNowBottomSheet {
  static RxInt selectedIndex = 0.obs;
  static Future<void> onShow({required BuildContext context}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: Get.height,
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.tabBackground.withValues(alpha: 0.8),
      builder: (context) => Container(
        height: 500,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
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
                    "Give A Review",
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(AppAsset.icClose, color: AppColors.unselected, width: 15),
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
                    itemCount: 4,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Obx(
                        () => RateItemWidget(
                          title: "Devils Wears",
                          description: "Kendow Premium T-shirt Most Popular",
                          sizes: const ["S", "M", "XL", "XXL"],
                          price: "560.00",
                          image: Utils.image,
                          callback: () => selectedIndex.value = index,
                          isSelect: selectedIndex.value == index,
                        ),
                      );
                    },
                  ),
                ),
              ),
              MainButtonWidget(
                height: 60,
                width: Get.width,
                color: AppColors.yellow,
                margin: const EdgeInsets.all(10),
                child: Text(
                  St.rateNow.tr,
                  style: AppFontStyle.styleW700(AppColors.black, 15),
                ),
                callback: () {
                  // Get.back();
                  GiveReviewBottomSheet.onShow(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RateItemWidget extends StatelessWidget {
  const RateItemWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.sizes,
      required this.price,
      required this.image,
      required this.callback,
      required this.isSelect});

  final String title;
  final String description;
  final String image;
  final List sizes;
  final String price;
  final Callback callback;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 105,
        width: Get.width,
        margin: const EdgeInsets.only(bottom: 15),
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.start,
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
            CustomRadioButton(size: 25, isSelect: isSelect),
            3.width,
          ],
        ),
      ),
    );
  }
}
