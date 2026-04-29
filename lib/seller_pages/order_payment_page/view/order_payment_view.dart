import 'dart:math' as math;

import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/order_payment_page/controller/order_payment_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OrderPaymentView extends StatelessWidget {
    OrderPaymentView({super.key});
  OrderPaymentController orderPaymentController = Get.put(OrderPaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,

          flexibleSpace: SimpleAppBarWidget(title: St.payment.tr),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                St.paymentMethod.tr,
                style: AppFontStyle.styleW700(AppColors.white, 18),
              ),
              20.height,
              GetBuilder<OrderPaymentController>(
                id: "onChangePaymentMethod",
                builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(visible: isShowRazorPayPaymentMethod, child: PaymentItemUi(0)),
                    Visibility(visible: isShowStripePaymentMethod, child: PaymentItemUi(1)),
                    Visibility(visible: isShowFlutterWavePaymentMethod, child: PaymentItemUi(2)),
                    Visibility(visible: isShowCashOnDelivery, child: PaymentItemUi(3)),
                    Visibility(visible: isShowPaystackPaymentMethod, child: PaymentItemUi(4)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<OrderPaymentController>(
         builder: (controller) =>
         Padding(
          padding: const EdgeInsets.all(15),
          child: MainButtonWidget(
            height: 60,
            width: Get.width,
            callback:controller.onClickPayNow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  St.payNow.tr,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppFontStyle.styleW700(AppColors.black, 15),
                ),
                8.width,
                Image.asset(AppAsset.icDoubleArrowRight, width: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentItemUi extends GetView<OrderPaymentController> {
  const PaymentItemUi(this.index, {super.key});

  final int index;
  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedPaymentMethod == index;

    return GestureDetector(
       onTap: () => controller.onChangePaymentMethod(index),
      child: Container(
        height: 65,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 10),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                child: _buildPaymentIcon(controller.paymentMethodList[index]["icon"] ?? "").paddingAll(8),
              ),
            ),
            Text(
              controller.paymentMethodList[index]["title"]??"",
              style: AppFontStyle.styleW700(AppColors.white, 15),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryPink : null,
                  border: isSelected ? null : Border.all(color: Colors.grey.shade400),
                ),
                child: isSelected ? const Icon(Icons.done_outlined, color: Colors.black, size: 15) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renders an icon from either a raster (`Image.asset`) or vector
  /// (`SvgPicture.asset`) source, picking based on the file extension.
  ///
  /// The square PNG logos (Razorpay, Stripe, FlutterWave, COD) keep their
  /// existing `height: 30` look. SVGs go through BoxFit.contain so a wide
  /// wordmark like Paystack scales down to the inner padded area without
  /// overflowing the 50×50 white box.
  Widget _buildPaymentIcon(String iconPath) {
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(iconPath, fit: BoxFit.contain);
    }
    return Image.asset(iconPath, height: 30);
  }
}


final randomNumber = ''.obs;
final enteredNumber = ''.obs;
final isLoading = false.obs;

void generateRandomNumber() {
  final random = math.Random();
  randomNumber.value = (1000 + random.nextInt(9000)).toString();
}

void showVerificationDialog({
  required Function() onVerified,
}) {
  generateRandomNumber();

  Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: AppColors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.height,
              FittedBox(
                child: Text(
                  St.verificationRequired.tr,
                  style: AppFontStyle.styleW800(AppColors.black, 22),
                ),
              ),
              SizedBox(height: 16),

              // Description
              Text(
                St.pleaseEnterThisNumberToConfirmYourOrder.tr,
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW600(AppColors.unselected, 14),
              ),
              20.height,

              // Random Number Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xffFFF5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  randomNumber.value,
                  style: TextStyle(letterSpacing: 6, fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xffF46B6B)),
                ),
              ),
              24.height,
              Pinput(
                length: 4,
                onChanged: (value) => enteredNumber.value = value,
                onCompleted: (value) => enteredNumber.value = value,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.black, 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.unselected.withValues(alpha: .7), width: 1),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.black, 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.unselected, width: 2),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.black, 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.unselected, width: 1),
                  ),
                ),
                errorPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.red, 18),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.red, width: 2),
                  ),
                ),
                cursor: Container(
                  width: 1,
                  height: 20,
                  color: AppColors.primary,
                ),
              ),
              20.height,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.red,
                  ),
                  height: 52,
                  width: Get.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(St.cancelText.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                      ],
                    ),
                  ),
                ),
              ),
              10.height,
              Obx(
                    () => GestureDetector(
                  onTap: enteredNumber.value == randomNumber.value
                      ? () {
                    Get.back();
                    onVerified();
                  }
                      : () {
                    Utils.showToast(St.verificationFailedPleaseCheckTheCodeAndTryAgain.tr);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: enteredNumber.value == randomNumber.value ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.2),
                    ),
                    height: 52,
                    width: Get.width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(St.submit.tr, style: AppFontStyle.styleW700(enteredNumber.value == randomNumber.value ? AppColors.black : AppColors.unselected, 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

