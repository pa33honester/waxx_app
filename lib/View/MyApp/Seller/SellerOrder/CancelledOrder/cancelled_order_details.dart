// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Controller/GetxController/seller/seller_status_wise_order_details_controller.dart';

class CancelledOrderDetails extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? productImage;
  final String? productName;
  final int? productQuantity;
  final int? productPrice;
  final String? shippingAddressName;
  final String? shippingCharge;
  final String? itemDiscount;
  final String? itemDiscountRate;
  final String? shippingAddressCountry;
  final String? shippingAddressState;
  final String? shippingAddressCity;
  final String? shippingAddressZipCode;
  final String? shippingAddress;
  final String? paymentGateway;
  final String? orderDate;
  final String? orderId;
  final List<dynamic>? attributesArray;

  CancelledOrderDetails({
    Key? key,
    this.startDate,
    this.endDate,
    this.status,
    this.productImage,
    this.productName,
    this.productQuantity,
    this.productPrice,
    this.shippingAddressName,
    this.shippingAddressCountry,
    this.shippingAddressState,
    this.shippingAddressCity,
    this.shippingAddressZipCode,
    this.shippingAddress,
    this.paymentGateway,
    this.orderDate,
    this.orderId,
    this.shippingCharge,
    this.itemDiscount,
    this.itemDiscountRate,
    this.attributesArray,
  }) : super(key: key);

  SellerStatusWiseOrderDetailsController sellerStatusWiseOrderDetailsController = Get.put(SellerStatusWiseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    final total = (productPrice ?? 0) - (double.tryParse(itemDiscount ?? "0") ?? 0);
    final finalTotal = (total) + (double.tryParse(shippingCharge ?? "0") ?? 0);
    return Scaffold(
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                10.height,
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.tabBackground,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
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
                      /* Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "$mobileNumber",
                                    style: AppFontStyle.styleW600(AppColors.white, 14.4),
                                  ),
                                ),*/
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
                                      style: AppFontStyle.styleW500(
                                          AppColors.unselected, 13),
                                    ),
                                    10.height,*/
                                    Text(
                                      St.date.tr,
                                      style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                    ),
                                    /*  10.height,
                                    Text(
                                      St.noReceipt.tr,
                                      style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                    ),
                                    10.height,
                                    Text(
                                      St.transactionID.tr,
                                      style: AppFontStyle.styleW500(AppColors.unselected, 13),
                                    ),*/
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
                                    /* Text(
                                      "$orderId",
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW600(
                                          AppColors.white, 13),
                                    ),
                                    10.height,*/

                                    Text(
                                      "$orderDate",
                                      style: AppFontStyle.styleW600(AppColors.white, 13),
                                    ),
                                    /* 10.height,
                                    Text(
                                      "1243736326278",
                                      style: AppFontStyle.styleW600(AppColors.white, 13),
                                    ),
                                    10.height,
                                    Text(
                                      "3960022513615131",
                                      style: AppFontStyle.styleW600(AppColors.white, 13),
                                    ),*/
                                    10.height,
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: AppColors.primaryRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          St.cancelledText.tr,
                                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primaryRed, fontSize: 12),
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

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
