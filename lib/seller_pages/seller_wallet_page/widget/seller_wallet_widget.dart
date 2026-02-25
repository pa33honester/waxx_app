import 'package:era_shop/seller_pages/seller_wallet_page/controller/seller_wallet_controller.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioItem extends StatelessWidget {
  const RadioItem({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: AppColors.transparent,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Container(
              height: 14,
              width: 14,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.grayLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawDetailsItemUi extends StatelessWidget {
  const WithdrawDetailsItemUi({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.styleW500(AppColors.unselected, 14),
        ),
        5.height,
        Container(
          height: 54,
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  controller: controller,
                  style: AppFontStyle.styleW700(AppColors.white, 14),
                  cursorColor: AppColors.unselected,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your ${title.toLowerCase()}...",
                    hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EnterAmountFieldUi extends GetView<SellerWalletController> {
  const EnterAmountFieldUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: AppFontStyle.styleW500(AppColors.coloGreyText, 14),
        ),
        5.height,
        Container(
          height: 54,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.tabBackground.withValues(alpha: 0.6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 54,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    "$currencySymbol",
                    style: AppFontStyle.styleW500(AppColors.black, 25),
                  ),
                ),
              ),
              15.width,
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: controller.amountController,
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                  cursorColor: AppColors.white,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter withdraw amount',
                    hintStyle: AppFontStyle.styleW400(AppColors.white, 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        2.height,
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Minimum Withdraw $currencySymbol$minPayout Amount",
            style: AppFontStyle.styleW600(AppColors.red, 11.5),
          ),
        ),
      ],
    );
  }
}
