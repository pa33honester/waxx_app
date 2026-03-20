import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class GiveReviewBottomSheet {
  static RxInt selectedIndex = 0.obs;
  static Future<void> onShow({required BuildContext context}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: Get.height,
      context: context,
      barrierColor: AppColors.tabBackground.withValues(alpha: 0.8),
      backgroundColor: AppColors.transparent,
      builder: (context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SingleChildScrollView(
            child: Container(
              height: 460,
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
                    15.height,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                            width: Get.width,
                            child: Center(
                              child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 45,
                                unratedColor: AppColors.white,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                                itemBuilder: (context, _) => Icon(Icons.star_rounded, color: AppColors.yellow),
                                onRatingUpdate: (rating) {},
                              ),
                            ),
                          ),
                          15.height,
                          Text(
                            St.detailReview.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                          ),
                          25.height,
                          Container(
                            height: 150,
                            width: Get.width,
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: AppColors.tabBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: St.enterYourPromoCode.tr,
                                hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MainButtonWidget(
                      height: 60,
                      width: Get.width,
                      color: AppColors.primary,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        St.submit.tr,
                        style: AppFontStyle.styleW700(AppColors.black, 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
