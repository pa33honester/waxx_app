import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/controller/seller_wallet_controller.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/widget/seller_wallet_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SellerWalletView extends GetView<SellerWalletController> {
  SellerWalletView({super.key});

  final sellerWalletController = Get.put(SellerWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.myWallet.tr),
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/sellerWithdrawPage')?.then(
                  (value) {
                    controller.withdrawMethods = [];
                    controller.withdrawPaymentDetails = [];
                    controller.fetchWithdrawListModel = null;
                    controller.selectedPaymentMethod = null;
                    controller.isShowPaymentMethod = false;
                    controller.amountController.clear();

                    controller.init();
                  },
                );
              },
              child: Image.asset(AppAsset.icWithdraw, width: 26).paddingOnly(right: 15),
            ),
          ],
        ),
      ),
      body: GetBuilder<SellerWalletController>(
          id: "onGetWithdrawMethods",
          builder: (controller) {
            return controller.isLoading
                ? Shimmers.withdrawShimmer()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/sellerWalletHistoryPage")?.then(
                                (value) {
                                  controller.withdrawMethods = [];
                                  controller.withdrawPaymentDetails = [];
                                  controller.fetchWithdrawListModel = null;
                                  controller.selectedPaymentMethod = null;
                                  controller.isShowPaymentMethod = false;
                                  controller.amountController.clear();
                                  controller.init();
                                },
                              );
                            },
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: AppColors.tabBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.unselected.withValues(alpha: 0.6),
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        St.totalEarning.tr,
                                        style: AppFontStyle.styleW600(AppColors.unselected, 16),
                                      ),
                                      5.height,
                                      controller.totalAmount == null
                                          ? Shimmer.fromColors(
                                              baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                                              highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                                              child: Container(
                                                height: 20,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "$currencySymbol ${controller.totalAmount}",
                                              style: AppFontStyle.styleW800(AppColors.primary, 20),
                                            ),
                                    ],
                                  ),
                                  Image.asset(
                                    AppAsset.icDoubleArrowRight,
                                    color: AppColors.unselected,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          22.height,
                          EnterAmountFieldUi(),
                          10.height,
                          Text(
                            St.selectPaymentGateway.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          5.height,
                          GetBuilder<SellerWalletController>(
                            id: "onSwitchWithdrawMethod",
                            builder: (controller) => GestureDetector(
                              onTap: controller.onSwitchWithdrawMethod,
                              child: Container(
                                height: 54,
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: AppColors.unselected.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.unselected.withValues(alpha: 0.6)),
                                ),
                                child: controller.selectedPaymentMethod == null
                                    ? Row(
                                        children: [
                                          5.width,
                                          Text(
                                            St.selectPaymentGateway.tr,
                                            style: AppFontStyle.styleW700(AppColors.unselected, 14),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.white,
                                            size: 22,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 35,
                                            child: Center(
                                              child: CachedNetworkImage(
                                                imageUrl: controller.withdrawMethods[controller.selectedPaymentMethod ?? 0].image ?? "",
                                                height: 26,
                                              ),
                                            ),
                                          ),
                                          15.width,
                                          Text(
                                            controller.withdrawMethods[controller.selectedPaymentMethod ?? 0].name ?? "",
                                            style: AppFontStyle.styleW700(AppColors.white, 15),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.white,
                                            size: 26,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          GetBuilder<SellerWalletController>(
                            id: "onChangePaymentMethod",
                            builder: (controller) => AnimatedContainer(
                              duration: Duration(milliseconds: 1000),
                              height: controller.isShowPaymentMethod ? (controller.withdrawMethods.length * 70) : 0,
                              color: AppColors.transparent,
                              curve: Curves.linearToEaseOut,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    15.height,
                                    for (int index = 0; index < controller.withdrawMethods.length; index++)
                                      GestureDetector(
                                        onTap: () => controller.onChangePaymentMethod(index),
                                        child: Container(
                                          height: 54,
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          margin: EdgeInsets.only(bottom: 15),
                                          decoration: BoxDecoration(
                                            color: AppColors.unselected.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.6)),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 35,
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller.withdrawMethods[index].image ?? "",
                                                    height: 26,
                                                  ),
                                                ),
                                              ),
                                              15.width,
                                              Text(
                                                controller.withdrawMethods[index].name ?? "",
                                                style: AppFontStyle.styleW700(AppColors.white, 15),
                                              ),
                                              Spacer(),
                                              RadioItem(isSelected: controller.selectedPaymentMethod == index),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          15.height,
                          GetBuilder<SellerWalletController>(
                            id: "onChangePaymentMethod",
                            builder: (controller) => controller.selectedPaymentMethod == null
                                ? Offstage()
                                : Column(
                                    children: [
                                      for (int i = 0; i < controller.withdrawMethods[controller.selectedPaymentMethod ?? 0].details!.length; i++)
                                        WithdrawDetailsItemUi(
                                          title: controller.withdrawMethods[controller.selectedPaymentMethod ?? 0].details?[i] ?? "",
                                          controller: controller.withdrawPaymentDetails[i],
                                        ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
      bottomNavigationBar: GetBuilder<SellerWalletController>(
        id: "onGetWithdrawMethods",
        builder: (controller) => Visibility(
          visible: controller.isLoading == false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: MainButtonWidget(
              height: 56,
              color: AppColors.primary,
              callback: controller.onClickWithdraw,
              child: Text(
                St.withdraw.tr,
                style: AppFontStyle.styleW700(AppColors.black, 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
