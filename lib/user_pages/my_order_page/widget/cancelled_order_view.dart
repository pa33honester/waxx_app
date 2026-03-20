import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/user_pages/my_order_page/widget/processing_order_view.dart';
import 'package:waxxapp/user_pages/my_order_page/widget/rate_now_bottom_sheet.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelledOrderView extends StatelessWidget {
  const CancelledOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: AppColors.tabBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "INV #213546",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppFontStyle.styleW700(AppColors.unselected, 12),
                    ),
                    10.width,
                    MainButtonWidget(
                      height: 24,
                      width: 68,
                      color: AppColors.redBackground,
                      borderRadius: 5,
                      child: Text(
                        St.cancelledText.tr,
                        style: AppFontStyle.styleW500(AppColors.red, 10),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "24 Nov 2022",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppFontStyle.styleW500(AppColors.unselected, 10),
                    ),
                  ],
                ),
                for (int i = 0; i < index + 1; i++)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: OrderProductItemWidget(
                      title: "Devils Wears",
                      description: "Kendow Premium T-shirt Most Popular",
                      sizes: const ["S", "M", "XL", "XXL"],
                      price: "560.00",
                      image: Utils.image,
                      callback: () {},
                    ),
                  ),
                20.height,
                DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
                15.height,
                Row(
                  children: [
                    Text(
                      "Total Amount",
                      style: AppFontStyle.styleW700(AppColors.unselected, 14),
                    ),
                    const Spacer(),
                    Text(
                      "$currencySymbol 640.00",
                      style: AppFontStyle.styleW900(AppColors.primary, 14),
                    ),
                  ],
                ),
                15.height,
                MainButtonWidget(
                  height: 60,
                  width: Get.width,
                  color: AppColors.white,
                  child: Text(
                    St.rateNow.tr,
                    style: AppFontStyle.styleW700(AppColors.black, 15),
                  ),
                  callback: () => RateNowBottomSheet.onShow(context: context),
                ),
                5.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
