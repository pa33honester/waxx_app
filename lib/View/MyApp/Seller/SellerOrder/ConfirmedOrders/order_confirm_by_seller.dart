// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Controller/GetxController/seller/update_status_wise_order_controller.dart';
import '../../../../../utils/app_circular.dart';
import '../../../../../utils/show_toast.dart';

class OrderConfirmBySeller extends StatelessWidget {
  final String? productImage;
  final String? productName;
  final int? productQuantity;
  final String? shippingCharge;
  final int? productPrice;
  final String? deliveryStatus;
  final String? userFirstName;
  final String? userLastName;
  final String? userId;
  final String? mobileNumber;
  final List<dynamic>? attributesArray;
  final String? shippingAddressCountry;
  final String? shippingAddressState;
  final String? shippingAddressCity;
  final int? shippingAddressZipCode;
  final String? shippingAddress;
  final String? paymentGateway;
  final String? orderDate;
  final String? orderId;

  OrderConfirmBySeller(
      {Key? key,
      this.productImage,
      this.productName,
      this.productQuantity,
      this.productPrice,
      this.userFirstName,
      this.userLastName,
      this.mobileNumber,
      this.shippingCharge,
      this.shippingAddressCountry,
      this.shippingAddressState,
      this.shippingAddressCity,
      this.shippingAddressZipCode,
      this.shippingAddress,
      this.deliveryStatus,
      this.attributesArray,
      this.paymentGateway,
      this.orderDate,
      this.orderId,
      this.userId})
      : super(key: key);

  UpdateStatusWiseOrderController updateStatusWiseOrderController = Get.put(UpdateStatusWiseOrderController());

  @override
  Widget build(BuildContext context) {
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
                                Column(
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
                                    Row(
                                      children: [
                                        Text(
                                          "${St.qty.tr} : ",
                                          style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: .5), 14),
                                        ),
                                        Text(
                                          "$productQuantity",
                                          style: AppFontStyle.styleW600(AppColors.primary, 15),
                                        ),
                                      ],
                                    ),
                                    2.height,
                                    Row(
                                      children: [
                                        Text(
                                          "${St.price.tr} : ",
                                          style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: .5), 14),
                                        ),
                                        Text(
                                          "$currencySymbol$productPrice",
                                          style: AppFontStyle.styleW600(AppColors.primary, 15),
                                        )
                                      ],
                                    ),
                                    2.height,
                                    Row(
                                      children: [
                                        Text(
                                          "${St.shippingCharge.tr} : ",
                                          style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: .5), 14),
                                        ),
                                        Text(
                                          "$currencySymbol$shippingCharge",
                                          style: AppFontStyle.styleW600(AppColors.primary, 15),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          26.height,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  St.deliveryBy.tr,
                                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                ),
                              ],
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: AppColors.tabBackground,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                filled: true,
                                fillColor: AppColors.tabBackground,
                                hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                enabledBorder: OutlineInputBorder(borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(12)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(12))),
                            hint: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                St.fedEx.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                            ),
                            icon: const Icon(Icons.expand_more_outlined),
                            alignment: Alignment.center,
                            isExpanded: true,
                            items: <String>[
                              'Delhivery',
                              "DTDC",
                              "Blue Dart",
                              'Ecom Express',
                              'Safe Express',
                              "Shadowfax",
                              "Xpressbess",
                            ].map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppFontStyle.styleW500(AppColors.white, 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              updateStatusWiseOrderController.deliveredServiceName = value;
                              log("$value");
                            },
                          ),
                          const SizedBox(height: 18),
                          PrimaryTextField(
                            titleText: St.trackingId.tr,
                            hintText: "TRA987654",
                            controllerType: "TrackingId",
                          ),
                          const SizedBox(height: 18),
                          PrimaryTextField(
                            titleText: St.trackingLink.tr,
                            hintText: "http://tracker.com",
                            controllerType: "TrackingLink",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: GestureDetector(
                      onTap: isDemoSeller == true
                          ? () => displayToast(message: St.thisIsDemoUser.tr)
                          : () async {
                              if (updateStatusWiseOrderController.trackingLinkController.text.isBlank == false ||
                                  updateStatusWiseOrderController.trackingIdController.text.isBlank == false ||
                                  updateStatusWiseOrderController.trackingIdController.text.isBlank == false) {
                                await updateStatusWiseOrderController.updateOrderStatus(userId: "$userId");
                                if (updateStatusWiseOrderController.updateStatusWiseOrder!.status == true) {
                                  displayToast(message: St.orderOutOfDelivery.tr);
                                  Get.back();
                                  // Get.back();
                                } else {
                                  displayToast(message: St.thisOrderIsAlreadyConfirmed.tr);
                                }
                              } else {
                                displayToast(message: St.allFieldFillAreRequired.tr);
                              }
                            },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            St.submit.tr,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700),
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
        Obx(() => updateStatusWiseOrderController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox())
      ],
    );
  }
}
