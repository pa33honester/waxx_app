import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Controller/GetxController/seller/update_status_wise_order_controller.dart';
import 'package:era_shop/utils/app_colors.dart';
import '../../../../../utils/app_circular.dart';
import '../../../../../utils/globle_veriables.dart';

// ignore: must_be_immutable
class OutOfDeliveryOrdersDetails extends StatelessWidget {
  final String? productImage;
  final String? productName;
  final int? productQuantity;
  final String? shippingCharge;
  final String? itemDiscount;
  final String? itemDiscountRate;
  final int? productPrice;
  final String? deliveryStatus;
  final String? trackingId;
  final String? trackingLink;
  final String? userFirstName;
  final String? userLastName;
  final String? userId;
  final String? mobileNumber;
  final List<dynamic>? attributesArray;
  final String? shippingAddressCountry;
  final String? shippingAddressState;
  final String? shippingAddressCity;
  final String? shippingAddressZipCode;
  final String? shippingAddress;
  final String? paymentGateway;
  final int? paymentStatus;
  final String? orderDate;
  final String? orderId;

  OutOfDeliveryOrdersDetails({
    super.key,
    this.productImage,
    this.productName,
    this.productQuantity,
    this.shippingCharge,
    this.productPrice,
    this.deliveryStatus,
    this.userFirstName,
    this.userLastName,
    this.userId,
    this.mobileNumber,
    this.attributesArray,
    this.shippingAddressCountry,
    this.shippingAddressState,
    this.shippingAddressCity,
    this.shippingAddressZipCode,
    this.shippingAddress,
    this.paymentGateway,
    this.paymentStatus,
    this.orderDate,
    this.orderId,
    this.itemDiscount,
    this.itemDiscountRate,
    this.trackingId,
    this.trackingLink,
  });

  UpdateStatusWiseOrderController updateStatusWiseOrderController = Get.put(UpdateStatusWiseOrderController());

  @override
  Widget build(BuildContext context) {
    final total = (productPrice ?? 0) - (double.tryParse(itemDiscount ?? "0") ?? 0);
    final finalTotal = (total) + (double.tryParse(shippingCharge ?? "0") ?? 0);

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.transparent,
              surfaceTintColor: AppColors.transparent,
              flexibleSpace: SimpleAppBarWidget(title: St.orderDetails.tr),
            ),
          ),
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite, borderRadius: BorderRadius.circular(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.height,
                                Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      // Container(
                                      //   height: 112,
                                      //   width: 100,
                                      //   decoration: BoxDecoration(
                                      //       image: DecorationImage(
                                      //           image: NetworkImage(productImage.toString()), fit: BoxFit.cover),
                                      //       borderRadius: BorderRadius.circular(10)),
                                      // ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: productImage.toString(),
                                          placeholder: (context, url) => const Center(
                                              child: CupertinoActivityIndicator(
                                            animating: true,
                                          )),
                                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                        ),
                                      ),
                                      14.width,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: Get.width / 2,
                                              child: Text(
                                                "$productName",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppFontStyle.styleW700(AppColors.white, 15),
                                              ),
                                            ),
                                            4.height,
                                            ListView.builder(
                                              itemCount: attributesArray!.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final attribute = attributesArray![index];
                                                return RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${attribute["name"]} : '.capitalizeFirst,
                                                        style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: .5), 13),
                                                      ),
                                                      TextSpan(
                                                        text: '${attribute["values"].join(", ")}',
                                                        style: AppFontStyle.styleW500(AppColors.primaryPink, 13),
                                                      ),
                                                    ],
                                                  ),
                                                ).paddingOnly(bottom: 3);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.height,
                                /*Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: GeneralTitle(title: "$userFirstName $userLastName"),
                                ),*/
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: GeneralTitle(title: St.productDetails.tr),
                                ),
                                Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            color: AppColors.primary,
                                            image: AssetImage(AppImage.location),
                                            height: 15,
                                          ),
                                          6.width,
                                          Text(
                                            St.location.tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppFontStyle.styleW600(AppColors.primary, 16),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                                      2.height,
                                      Text(
                                        Utils.buildAddressString(shippingAddress, shippingAddressCity, shippingAddressState, shippingAddressCountry, shippingAddressZipCode),
                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                      ),
                                    ],
                                  ),
                                ),
                                16.height,
                                Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        St.paymentDetails.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.styleW600(AppColors.primary, 16),
                                      ),
                                      Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                St.qty.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              10.height,
                                              Text(
                                                St.paymentMethod.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              10.height,
                                              Text(
                                                St.price.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              if (itemDiscount != "0") ...{
                                                10.height,
                                                Text(
                                                  St.discount.tr,
                                                  style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                                ),
                                                10.height,
                                                Text(
                                                  St.finalTotal.tr,
                                                  style: AppFontStyle.styleW500(AppColors.tabBackground, 13),
                                                ),
                                              },
                                              10.height,
                                              Text(
                                                St.shippingCharge.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "$productQuantity",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                              10.height,
                                              Text(
                                                "$paymentGateway",
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                              10.height,
                                              Text(
                                                "$currencySymbol$productPrice",
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                              if (itemDiscount != "0") ...{
                                                10.height,
                                                Text(
                                                  "$currencySymbol$itemDiscount",
                                                  style: AppFontStyle.styleW600(AppColors.red, 13),
                                                ),
                                                10.height,
                                                Text(
                                                  '$currencySymbol$total',
                                                  style: AppFontStyle.styleW600(AppColors.white, 13),
                                                ),
                                              },
                                              10.height,
                                              Text(
                                                "$currencySymbol$shippingCharge",
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            St.finalTotal.tr,
                                            style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                          ),
                                          Text(
                                            "$currencySymbol$finalTotal",
                                            style: AppFontStyle.styleW700(AppColors.primary, 14),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                //****************** DELIVERY DETAILS *******************
                                16.height,
                                Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        St.deliveryDetails.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.styleW600(AppColors.primary, 16),
                                      ),
                                      Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /* Text(
                                                St.deliveryCode.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),*/
                                              Text(
                                                St.transactionID.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              10.height,
                                              Text(
                                                St.trackingLink.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              10.height,
                                              Text(
                                                St.date.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                              10.height,
                                              Text(
                                                St.deliveryStatus.tr,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              /*Text(
                                                "$orderId",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),*/
                                              10.height,
                                              GestureDetector(
                                                onLongPress: () {
                                                  if (trackingId != null && trackingId!.isNotEmpty) {
                                                    Clipboard.setData(ClipboardData(text: trackingId!));
                                                    displayToast(message: 'Link copied!');
                                                  }
                                                },
                                                child: Text(
                                                  "$trackingId",
                                                  style: AppFontStyle.styleW600(AppColors.white, 13),
                                                ),
                                              ),
                                              10.height,
                                              GestureDetector(
                                                onLongPress: () {
                                                  if (trackingLink != null && trackingLink!.isNotEmpty) {
                                                    Clipboard.setData(ClipboardData(text: trackingLink!));
                                                    displayToast(message: 'Link copied!');
                                                  }
                                                },
                                                child: Text(
                                                  "$trackingLink",
                                                  style: AppFontStyle.styleW600(AppColors.white, 13),
                                                ),
                                              ),
                                              10.height,
                                              Text(
                                                "$orderDate",
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                              10.height,
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                    color: Color(deliveryStatus == "Pending"
                                                        ? 0xffFFF2ED
                                                        : deliveryStatus == "Confirmed"
                                                            ? 0xffE6F9F0
                                                            : deliveryStatus == "Out Of Delivery"
                                                                ? 0xffFFFAE8
                                                                : deliveryStatus == "Delivered"
                                                                    ? 0xffF4F0FF
                                                                    : deliveryStatus == "Cancelled"
                                                                        ? 0xffFFEDED
                                                                        : 0xff),
                                                    borderRadius: BorderRadius.circular(5)),
                                                child: Center(
                                                  child: Text(
                                                    deliveryStatus == "Pending"
                                                        ? St.pending.tr
                                                        : deliveryStatus == "Confirmed"
                                                            ? St.confirmed.tr
                                                            : deliveryStatus == "Out Of Delivery"
                                                                ? St.outOfDelivery.tr
                                                                : deliveryStatus == "Delivered"
                                                                    ? St.deliveredText.tr
                                                                    : deliveryStatus == "Cancelled"
                                                                        ? St.cancelledText.tr
                                                                        : "",
                                                    style: GoogleFonts.plusJakartaSans(
                                                        color: Color(
                                                          deliveryStatus == "Pending"
                                                              ? 0xffFF784B
                                                              : deliveryStatus == "Confirmed"
                                                                  ? 0xff00C566
                                                                  : deliveryStatus == "Out Of Delivery"
                                                                      ? 0xffFACC15
                                                                      : deliveryStatus == "Delivered"
                                                                          ? 0xff936DFF
                                                                          : deliveryStatus == "Cancelled"
                                                                              ? 0xffFF4747
                                                                              : 0xff,
                                                        ),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PrimaryPinkButton(
                          onTaped: isDemoSeller == true
                              ? () => displayToast(message: St.thisIsDemoUser.tr)
                              : () async {
                                  if (paymentStatus == 1) {
                                    Get.dialog(
                                      barrierDismissible: false,
                                      barrierColor: AppColors.black.withValues(alpha: 0.9),
                                      Dialog(
                                        backgroundColor: AppColors.transparent,
                                        elevation: 0,
                                        child: Container(
                                          // height: 420,
                                          width: 310,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(45),
                                            color: AppColors.white,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 170,
                                                  width: 310,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.green,
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(45),
                                                      topLeft: Radius.circular(45),
                                                    ),
                                                  ),
                                                  child: Image.asset(AppAsset.imgSuccessOrder, width: 140),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        St.paymentConfirmation.tr,
                                                        style: AppFontStyle.styleW800(
                                                          Colors.black,
                                                          20,
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        St.thisOrderUnpaidHaveYouReceivedThePaymentFromCustomer.tr,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors.unselected,
                                                        ),
                                                      ),
                                                      20.height,
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Get.back();
                                                          await updateStatusWiseOrderController.confirmCodOrderItem(
                                                            userId: "$userId",
                                                          );
                                                          if (updateStatusWiseOrderController.updateStatusWiseOrder!.status == true) {
                                                            displayToast(message: St.orderDelivered.tr);
                                                            Get.back();
                                                          } else {
                                                            displayToast(message: St.thisOrderIsAlreadyAddedInDelivered.tr);
                                                          }

                                                          // if (success) {
                                                          //   displayToast(message: St.orderDelivered.tr);
                                                          //   Get.back();
                                                          // } else {
                                                          //   displayToast(message: St.thisOrderIsAlreadyAddedInDelivered.tr);
                                                          // }

                                                          // Get.back();
                                                          // await updateStatusWiseOrderController.updateOrderStatus(userId: "$userId");
                                                          // if (updateStatusWiseOrderController.updateStatusWiseOrder!.status == true) {
                                                          //   displayToast(message: St.orderDelivered.tr);
                                                          //   Get.back();
                                                          // } else {
                                                          //   displayToast(message: St.thisOrderIsAlreadyAddedInDelivered.tr);
                                                          // }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: AppColors.green,
                                                          ),
                                                          height: 52,
                                                          width: Get.width,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(St.yesIPaid.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      10.height,
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                          // Get.offAllNamed("/BottomTabBar");
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: AppColors.unselected.withValues(alpha: 0.2),
                                                          ),
                                                          height: 52,
                                                          width: Get.width,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(St.cancelText.tr, style: AppFontStyle.styleW700(AppColors.unselected, 16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    await updateStatusWiseOrderController.updateOrderStatus(userId: "$userId");
                                    if (updateStatusWiseOrderController.updateStatusWiseOrder?.status == true) {
                                      displayToast(message: St.orderDelivered.tr);
                                      Get.back();
                                    } else {
                                      displayToast(message: St.thisOrderIsAlreadyAddedInDelivered.tr);
                                    }
                                  }
                                  // await updateStatusWiseOrderController.updateOrderStatus(userId: "$userId");
                                  // if (updateStatusWiseOrderController.updateStatusWiseOrder!.status == true) {
                                  //   displayToast(message: St.orderDelivered.tr);
                                  //   Get.back();
                                  // } else {
                                  //   displayToast(message: St.thisOrderIsAlreadyAddedInDelivered.tr);
                                  // }
                                },
                          text: St.deliveredOrder.tr)
                      .paddingSymmetric(vertical: 15)
                ],
              ),
            ),
          ),
        ),
        Obx(() => updateStatusWiseOrderController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox())
      ],
    );
  }
}
