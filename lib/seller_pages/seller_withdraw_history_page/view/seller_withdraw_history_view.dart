import 'package:waxxapp/custom/custom_range_picker.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/seller_withdraw_history_page/controller/seller_withdraw_history_controller.dart';
import 'package:waxxapp/seller_pages/seller_withdraw_history_page/widget/seller_withdraw_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SellerWithdrawHistoryView extends StatelessWidget {
  SellerWithdrawHistoryView({super.key});

  final controller = Get.put(SellerWithdrawHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        shadowColor: AppColors.black.withValues(alpha: 0.4),
        surfaceTintColor: AppColors.transparent,
        flexibleSpace: SimpleAppBarWidget(title: St.myWallet.tr),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  St.withdrawHistory.tr,
                  style: AppFontStyle.styleW700(AppColors.white, 17),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    DateTimeRange? dateTimeRange = await CustomRangePicker.onShow(context);
                    if (dateTimeRange != null) {
                      String startDate = DateFormat('yyyy-MM-dd').format(dateTimeRange.start);
                      String endDate = DateFormat('yyyy-MM-dd').format(dateTimeRange.end);

                      final range = "${DateFormat('dd MMM').format(dateTimeRange.start)} - ${DateFormat('dd MMM').format(dateTimeRange.end)}";

                      Utils.showLog("Selected Date Range => $range");

                      controller.onChangeDate(startDate: startDate, endDate: endDate, rangeDate: range);

                      controller.onGetWithdrawHistory();
                    }
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GetBuilder<SellerWithdrawHistoryController>(
                          id: "onChangeDate",
                          builder: (controller) => Text(
                            controller.rangeDate,
                            style: AppFontStyle.styleW500(AppColors.white, 12),
                          ),
                        ),
                        8.width,
                        SizedBox(
                          height: 35,
                          width: 12,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  top: 12.5,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    size: 19,
                                    color: AppColors.white,
                                  )),
                              Positioned(
                                  top: 3.5,
                                  child: Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: 20,
                                    color: AppColors.white,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.init(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: Get.height + 1,
                  child: GetBuilder<SellerWithdrawHistoryController>(
                    id: "onGetWithdrawHistory",
                    builder: (controller) {
                      return controller.isLoading
                          ? Shimmers.coinHistoryShimmer()
                          : controller.withdrawHistory.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: noDataFound(image: "assets/no_data_found/basket.png").paddingOnly(bottom: 50),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () => controller.init(),
                                  color: AppColors.primary,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(left: 15, right: 15, top: 12),
                                    itemCount: controller.withdrawHistory.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final historyIndex = controller.withdrawHistory[index];
                                      return HistoryItemUi(
                                          title: historyIndex.status == 1
                                              ? St.pending.tr
                                              : historyIndex.status == 2
                                                  ? St.approved.tr
                                                  : St.rejected.tr,
                                          date: historyIndex.requestDate ?? "",
                                          uniqueId: historyIndex.uniqueId ?? "",
                                          coin: "${historyIndex.status == 1 || historyIndex.status == 3 ? "" : "-"} ${CustomFormatNumber.convert(historyIndex.amount ?? 0)}",
                                          reason: historyIndex.reason ?? "",
                                          containerColor: historyIndex.status == 1
                                              ? AppColors.redBackground
                                              : historyIndex.status == 2
                                                  ? AppColors.greenBackground
                                                  : AppColors.greyGreenBackground,
                                          titleColor: historyIndex.status == 1
                                              ? AppColors.red
                                              : historyIndex.status == 2
                                                  ? AppColors.green
                                                  : AppColors.primary);
                                    },
                                  ),
                                );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
