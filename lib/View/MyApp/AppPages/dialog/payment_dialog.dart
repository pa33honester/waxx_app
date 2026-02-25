import 'dart:async';

import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CongratulationsPaymentDialog extends StatefulWidget {
  final String orderId;
  final String productId;
  final String productName;
  final String amount;
  final String mainImage;
  final String shippingCharges;
  final String reminderMinutes;
  final List<Map<String, dynamic>> productAttributes;

  const CongratulationsPaymentDialog({
    super.key,
    required this.productName,
    required this.orderId,
    required this.productId,
    required this.amount,
    required this.mainImage,
    required this.shippingCharges,
    required this.reminderMinutes,
    required this.productAttributes,
  });

  @override
  State<CongratulationsPaymentDialog> createState() => _CongratulationsPaymentDialogState();
}

class _CongratulationsPaymentDialogState extends State<CongratulationsPaymentDialog> {
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (int.tryParse(widget.reminderMinutes) ?? 0) * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.unselected.withValues(alpha: 0.4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: AppColors.primary,
                  size: 45,
                ),
              ),
              16.height,
              Text(
                "🎉 ${St.congratulations.tr} 🎉",
                style: AppFontStyle.styleW800(AppColors.primary, 24),
                textAlign: TextAlign.center,
              ),
              8.height,
              Text(
                St.youWonTheAuction.tr,
                style: AppFontStyle.styleW600(AppColors.white, 18),
                textAlign: TextAlign.center,
              ),
              20.height,
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: PreviewImageWidget(
                              height: 80,
                              width: 80,
                              image: widget.mainImage,
                              defaultHeight: 80,
                              fit: BoxFit.cover,
                            )),
                        16.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productName,
                                style: AppFontStyle.styleW700(AppColors.white, 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              8.height,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (int i = 0; i < (widget.productAttributes[0]['values'].length ?? 0); i++)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.productAttributes[0]["values"]?[i].toUpperCase() ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(color: AppColors.unselected.withValues(alpha: 0.8), fontSize: 12),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              8.height,
                              Row(
                                children: [
                                  Text(
                                    St.winningBid.tr,
                                    style: TextStyle(color: AppColors.unselected, fontSize: 14),
                                  ),
                                  Text(
                                    "$currencySymbol ${widget.amount}",
                                    style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.height,
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        8.width,
                        Row(
                          children: [
                            Text(
                              St.completePaymentWithin.tr,
                              style: AppFontStyle.styleW600(AppColors.white, 14),
                            ),
                            4.width,
                            Text(_formatTime(_remainingSeconds), style: AppFontStyle.styleW700(AppColors.primary, 12)),
                          ],
                        ),
                      ],
                    ),
                    8.height,
                    8.height,
                    Text(
                      "⚠️ ${St.paymentMustBeCompletedWithinTheTimeLimitToSecureYourPurchase.tr}",
                      style: AppFontStyle.styleW400(AppColors.unselected, 12),
                    ),
                  ],
                ),
              ),
              24.height,
              MainButtonWidget(
                height: 50,
                width: Get.width,
                color: AppColors.primary,
                borderRadius: 12,
                callback: () {
                  Get.toNamed("/AuctionPayOrderDetails", arguments: {
                    "orderId": widget.orderId,
                    "productId": widget.productId,
                    "productName": widget.productName,
                    "amount": widget.amount,
                    "mainImage": widget.mainImage,
                    "shippingCharges": widget.shippingCharges,
                    "productAttributes": widget.productAttributes,
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      color: AppColors.black,
                      size: 20,
                    ),
                    8.width,
                    Text(
                      St.payNow.tr,
                      style: AppFontStyle.styleW700(AppColors.black, 16),
                    ),
                  ],
                ),
              ),
              12.height,
              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  St.iWillPayLater.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
