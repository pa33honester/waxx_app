import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/custom_range_picker.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/controller/seller_wallet_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SellerWalletHistoryView extends StatelessWidget {
  const SellerWalletHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        shadowColor: AppColors.black.withValues(alpha: 0.4),
        surfaceTintColor: AppColors.transparent,
        flexibleSpace: SimpleAppBarWidget(title: "Wallet History"),
      ),
      body: GetBuilder<SellerWalletController>(builder: (controller) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    St.walletHistory.tr,
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

                        controller.onGetWalletHistory();
                      }
                    },
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.unselected.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GetBuilder<SellerWalletController>(
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
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: Get.height + 1,
                    child: GetBuilder<SellerWalletController>(
                      id: "onGetWalletHistory",
                      builder: (controller) => controller.isLoading1
                          ? Shimmers.coinHistoryShimmer()
                          : controller.walletHistory.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: noDataFound(image: "assets/no_data_found/basket.png").paddingOnly(bottom: 50),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(left: 15, right: 15, top: 12),
                                  itemCount: controller.walletHistory.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final historyIndex = controller.walletHistory[index];

                                    return Container(
                                      height: 70,
                                      width: Get.width,
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.tabBackground,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.6)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          10.width,
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.unselected),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: historyIndex.transactionType == 1
                                                ? CachedNetworkImage(
                                                    imageUrl: "${historyIndex.productImage}",
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(AppAsset.icWallet).paddingAll(7),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  historyIndex.transactionType == 1 ? historyIndex.productName?.capitalizeFirst ?? "" : St.withdraw.tr,
                                                  style: AppFontStyle.styleW700(AppColors.white, 14),
                                                ),
                                                historyIndex.transactionType == 1
                                                    ? Text(
                                                        historyIndex.orderId ?? "",
                                                        style: AppFontStyle.styleW600(AppColors.unselected, 11),
                                                      )
                                                    : SizedBox(),
                                                2.height,
                                                Text(
                                                  historyIndex.date ?? "",
                                                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.width,
                                          Container(
                                            height: 32,
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            decoration: BoxDecoration(
                                              color: historyIndex.transactionType == 1 ? AppColors.greenBackground.withValues(alpha: 0.8) : AppColors.redBackground.withValues(alpha: 0.8),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                historyIndex.transactionType == 1 ? "+ ${historyIndex.amount?.toStringAsFixed(1)}" : "- ${historyIndex.amount?.toStringAsFixed(1)}",
                                                style: AppFontStyle.styleW700(historyIndex.transactionType == 1 ? AppColors.green : AppColors.red, 15),
                                              ),
                                            ),
                                          ),
                                          10.width,
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
