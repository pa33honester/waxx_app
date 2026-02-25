import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/custom_radio_button.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/user_pages/cancel_order_page/widget/cancelled_order_bottom_sheet.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CancelOrderView extends StatelessWidget {
  const CancelOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.cancelOrder.tr),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        height: 420,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            PageView.builder(
                              itemCount: 1,
                              onPageChanged: (value) {},
                              itemBuilder: (context, index) {
                                final indexData = Utils.image;
                                return PreviewImageWidget(height: 420, width: Get.width, image: indexData, fit: BoxFit.cover);
                              },
                            ),
                            Positioned(
                              bottom: 15,
                              child: SmoothPageIndicator(
                                effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primaryPink),
                                controller: PageController(),
                                count: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Fulking Awesome",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 20),
                                      ),
                                      Text(
                                        "Kendow Premium T-shirt For Men’s Wear Most Popular",
                                        style: TextStyle(fontWeight: FontWeight.w500, fontFamily: AppConstant.appFontRegular, color: AppColors.unselected, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                MainButtonWidget(
                                  height: 24,
                                  width: 68,
                                  color: AppColors.greyGreenBackground,
                                  borderRadius: 5,
                                  child: Text(
                                    "On Process",
                                    style: AppFontStyle.styleW500(AppColors.primary, 10),
                                  ),
                                ),
                              ],
                            ),
                            5.height,
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int i = 0; i < 1; i++)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: AppColors.unselected.withValues(alpha: 0.4)),
                                      ),
                                      child: Text(
                                        "XXL",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.8), 10),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "$currencySymbol 250.00",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w900, fontFamily: AppConstant.appFontRegular, color: AppColors.primary, fontSize: 20),
                                ),
                                10.width,
                                Text(
                                  "$currencySymbol 550.00",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: AppConstant.appFontRegular,
                                    color: AppColors.unselected,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                15.height,
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.tabBackground),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivery Details",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppFontStyle.styleW700(AppColors.primary, 14),
                      ),
                      15.height,
                      DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                      15.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            St.orderAmount.tr,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          Text(
                            "$currencySymbol 172.00",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(AppColors.white, 14),
                          ),
                        ],
                      ),
                      5.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            St.cancellationCharges.tr,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          Text(
                            "$currencySymbol 172.00",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(AppColors.primary, 14),
                          ),
                        ],
                      ),
                      15.height,
                      DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                      15.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            St.refundAmount.tr,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          Text(
                            "$currencySymbol 172.00",
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(AppColors.primary, 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                15.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomRadioButton(size: 20, isSelect: true),
                    15.width,
                    Expanded(
                      child: Text(
                        St.iAcceptAllTermsAndConditionForCancelOrderPolicy.tr,
                        style: AppFontStyle.styleW500(AppColors.white, 14),
                      ),
                    ),
                  ],
                ),
                15.height,
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: MainButtonWidget(
            height: 60,
            width: Get.width,
            color: AppColors.red,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                St.confirmCancelOrder.tr,
                style: AppFontStyle.styleW700(AppColors.white, 15),
              ),
            ),
            callback: () => CancelledOrderBottomSheet.onShow(
              callBack: () {},
            ),
          ),
        ),
      ),
    );
  }
}
