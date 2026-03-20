// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:waxxapp/View/MyApp/Profile/MyOrder/cancel_order_by_user.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../Controller/GetxController/user/create_rating_controller.dart';
import '../../../../Controller/GetxController/user/create_review_controller.dart';

class UserOrderDetails extends StatelessWidget {
  final String? mainImage;
  final String? productName;
  final List<dynamic>? attributesArray;
  final String? qty;
  final String? shippingCharge;
  final num? price;
  final String? userFirstName;
  final String? userLastName;
  final num? finalAmount;

  ///************* ADDRESS ****************\\\
  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? phoneNumber;

  ///************* ORDER DETAILS ****************\\\
  final String? orderId;

  // final String? noReceipt;

  ///************* PAYMENT DETAILS ****************\\\
  final String? paymentMethod;

  final String? transitionID;
  final String? date;
  final String? itemDiscount;
  final String? trackingLink;
  final String? deliveredServiceName;

  ///************* DELIVERY STATUS ****************\\\
  final String? deliveryStatus;

  UserOrderDetails(
      {super.key,
      this.productName,
      this.attributesArray,
      this.qty,
      this.shippingCharge,
      this.price,
      this.finalAmount,
      this.userFirstName,
      this.userLastName,
      this.name,
      this.address,
      this.city,
      this.state,
      this.country,
      this.zipCode,
      this.orderId,
      this.phoneNumber,
      this.paymentMethod,
      this.date,
      this.deliveryStatus,
      this.mainImage,
      this.transitionID,
      this.deliveredServiceName,
      this.itemDiscount,
      this.trackingLink});

  CreateReviewController createReviewController = Get.put(CreateReviewController());
  CreateRatingController createRatingController = Get.put(CreateRatingController());
  final productController = PageController();

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.transparent,
                surfaceTintColor: AppColors.transparent,
                flexibleSpace: SimpleAppBarWidget(title: St.productDetails.tr),
              ),
            ),
            body: SafeArea(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            15.height,
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: AppColors.tabBackground,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 420,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        PageView.builder(
                                          controller: productController,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return PreviewImageWidget(
                                              height: 420,
                                              width: Get.width,
                                              image: mainImage,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    productName ?? "",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppFontStyle.styleW700(AppColors.white, 20),
                                                  ),
                                                  4.height,
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        for (int i = 0; i < (attributesArray?[0]['values']?.length ?? 0); i++)
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                            margin: const EdgeInsets.only(right: 5),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                            child: Text(
                                                              attributesArray?[0]['values']?[i] ?? "",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(color: AppColors.unselected.withValues(alpha: 0.8), fontSize: 12),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.height,
                                        Row(
                                          children: [
                                            address != null || country != null
                                                ? Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          color: AppColors.unselected,
                                                          image: AssetImage(AppImage.location),
                                                          height: 15,
                                                        ),
                                                        5.width,
                                                        Expanded(
                                                          child: Text(
                                                            Utils.buildAddressString(address, city, state, country, zipCode),
                                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                        5.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "$currencySymbol $price",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppFontStyle.styleW900(AppColors.primary, 20),
                                            ),
                                            10.width,
                                            const Spacer(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            15.height,

                            ///TODO
                            // Column(
                            //     children: attributesArray?.map((key) {
                            //       return Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           key.capitalizeFirst.toString() == "Colors"
                            //               ? Padding(
                            //                   padding: const EdgeInsets.symmetric(vertical: 3),
                            //                   child: Text(
                            //                     "Select ${key.capitalizeFirst.toString()}",
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: AppFontStyle.styleW700(AppColors.white, 16),
                            //                   ),
                            //                 )
                            //               : Padding(
                            //                   padding: const EdgeInsets.symmetric(vertical: 3),
                            //                   child: Text(
                            //                     selectedValues[key] != null
                            //                         ? "Select ${key.capitalizeFirst.toString()} : ${selectedValues[key]}"
                            //                         : key.capitalizeFirst.toString(),
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: AppFontStyle.styleW700(AppColors.white, 16),
                            //                   ),
                            //                 ),
                            //           Padding(
                            //             padding: const EdgeInsets.symmetric(vertical: 8),
                            //             child: SizedBox(
                            //               height: Get.width * 0.11,
                            //               child: ListView.builder(
                            //                 padding: EdgeInsets.zero,
                            //                 scrollDirection: Axis.horizontal,
                            //                 itemCount: attributesArray?.length,
                            //                 itemBuilder: (context, index) {
                            //                   final value = attributesArray![index];
                            //                   final isSelected = selectedValues[key] == value;
                            //
                            //                   return GestureDetector(
                            //                       onTap: () {
                            //                         // setState(() {
                            //                         //   selectedValues[key] = value;
                            //                         //   log("selectedValues  $selectedValues");
                            //                         //   List<Map<String, String>> selectedValueList = selectedValues.entries
                            //                         //       .map((entry) => {entry.key: entry.value})
                            //                         //       .toList();
                            //                         //
                            //                         //   log("selectedValueList :: $selectedValueList");
                            //                         //   // aa value api ma moklwani thashe
                            //                         //   log("selectedValueList Json String :: ${jsonEncode(selectedValueList)}");
                            //                         //
                            //                         //   bool allAttributesFilled = userProductDetailsController
                            //                         //       .selectedValuesByType.keys
                            //                         //       .every((key) => selectedValues[key] != null);
                            //                         //   setState(() {
                            //                         //     areAllAttributesFilled = allAttributesFilled;
                            //                         //     log("Attrubutes Filled :: $areAllAttributesFilled");
                            //                         //   });
                            //                         //   log("All attributr selected or not :: $areAllAttributesFilled");
                            //                         // });
                            //
                            //                         // setState(() {
                            //                         //   if (isSelected) {
                            //                         //     selectedValues[key] = "";
                            //                         //   } else {
                            //                         //     selectedValues[key] = value;
                            //                         //   }
                            //                         // });
                            //                       },
                            //                       child: key.capitalizeFirst.toString() == "Colors"
                            //                           ? Container(
                            //                               height: Get.width * 0.11,
                            //                               width: Get.width * 0.13,
                            //                               decoration: BoxDecoration(
                            //                                   borderRadius: BorderRadius.circular(12),
                            //                                   border: Border.all(
                            //                                     color: isSelected ? AppColors.primaryPink : Colors.transparent,
                            //                                     width: 2,
                            //                                   )),
                            //                               child: Container(
                            //                                 decoration: BoxDecoration(
                            //                                   borderRadius: BorderRadius.circular(8),
                            //                                   color: Color(int.parse(value.replaceAll("#", "0xFF"))),
                            //                                 ),
                            //                               ).paddingAll(2),
                            //                             ).paddingOnly(right: 6)
                            //                           : Container(
                            //                               alignment: Alignment.center,
                            //                               // height: Get.width * 0.8,
                            //                               width: Get.width * 0.14,
                            //                               padding: const EdgeInsets.symmetric(horizontal: 10),
                            //                               decoration: BoxDecoration(
                            //                                 borderRadius: BorderRadius.circular(12),
                            //                                 color: isSelected ? AppColors.primaryPink : AppColors.tabBackground,
                            //                               ),
                            //                               child: FittedBox(
                            //                                 child: Text(
                            //                                   value,
                            //                                   style: AppFontStyle.styleW600(
                            //                                       isDark.value
                            //                                           ? AppColors.white
                            //                                           : isSelected
                            //                                               ? Colors.black
                            //                                               : AppColors.unselected,
                            //                                       16),
                            //                                 ),
                            //                               ),
                            //                             ).paddingOnly(right: 10));
                            //                 },
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     }).toList() ?? [ ],
                            //   ),

                            // 10.height,
                            // Row(
                            //   children: [
                            //     for (int i = 0; i < 3; i++)
                            //       const PreviewImageWidget(
                            //         height: 100,
                            //         width: 100,
                            //         radius: 10,
                            //         fit: BoxFit.cover,
                            //         margin: EdgeInsets.only(right: 10),
                            //         image: "https://petapixel.com/assets/uploads/2017/03/product1.jpeg",
                            //       ),
                            //   ],
                            // ),

                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //
                            //
                            //         ],
                            //       ),
                            //       InkWell(
                            //         onTap: () {
                            //           productId = "${userProductDetailsController.userProductDetails!.product![0].id}";
                            //           Get.toNamed("/ProductReviews");
                            //         },
                            //         child: SizedBox(
                            //           height: 40,
                            //           width: 80,
                            //           child: Align(
                            //             alignment: Alignment.centerRight,
                            //             child: Text(
                            //               St.seeAll.tr,
                            //               style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primaryPink),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.unselected.withValues(alpha:0.25)),
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
                                          if (itemDiscount != null && itemDiscount != '0') ...{
                                            10.height,
                                            Text(
                                              St.discount.tr,
                                              style: AppFontStyle.styleW500(AppColors.unselected, 13),
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
                                            "$qty",
                                            overflow: TextOverflow.ellipsis,
                                            style: AppFontStyle.styleW600(AppColors.white, 13),
                                          ),
                                          10.height,
                                          Text(
                                            "$paymentMethod",
                                            style: AppFontStyle.styleW600(AppColors.white, 13),
                                          ),
                                          10.height,
                                          Text(
                                            "$currencySymbol$price",
                                            style: AppFontStyle.styleW600(AppColors.white, 13),
                                          ),
                                          if (itemDiscount != null && itemDiscount != '0') ...{
                                            10.height,
                                            Text(
                                              "$currencySymbol$itemDiscount",
                                              style: AppFontStyle.styleW600(AppColors.red, 13),
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
                                        "$currencySymbol$finalAmount",
                                        style: AppFontStyle.styleW700(AppColors.primary, 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            16.height,
                            if (deliveryStatus == "Out Of Delivery" || deliveryStatus == "Delivered")
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
                                    2.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              St.trackingId.tr,
                                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                            ),
                                            10.height,
                                            Text(
                                              St.trackingLink.tr,
                                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                            ),
                                            10.height,
                                            Text(
                                              St.delivery.tr,
                                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                            ),
                                            10.height,
                                            Text(
                                              St.date.tr,
                                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onLongPress: () {
                                                if (transitionID != null && transitionID!.isNotEmpty) {
                                                  Clipboard.setData(ClipboardData(text: transitionID!));
                                                  displayToast(message: 'Copied!');
                                                }
                                              },
                                              child: Text(
                                                transitionID ?? "",
                                                overflow: TextOverflow.ellipsis,
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
                                                trackingLink ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW600(AppColors.white, 13),
                                              ),
                                            ),
                                            10.height,
                                            Text(
                                              deliveredServiceName ?? "",
                                              style: AppFontStyle.styleW600(AppColors.white, 13),
                                            ),
                                            10.height,
                                            Text(
                                              date ?? "",
                                              style: AppFontStyle.styleW600(AppColors.white, 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            20.height,
                            if (deliveryStatus == "Pending" || deliveryStatus == "Confirmed") ...{
                              PrimaryPinkButton(
                                      onTaped: () {
                                        Get.to(
                                          () => CancelOrderByUser(
                                            mainImage: mainImage,
                                            productName: productName,
                                            price: finalAmount,
                                          ),
                                          transition: Transition.rightToLeft,
                                        );
                                      },
                                      text: St.cancelOrder.tr)
                                  .paddingSymmetric(vertical: 22, horizontal: 15)
                            } else if (deliveryStatus == "Delivered") ...{
                              PrimaryPinkButton(
                                      onTaped: () => Get.bottomSheet(
                                            isScrollControlled: true,
                                            elevation: 10,
                                            rattingBottomSheet(),
                                          ),
                                      text: St.rateNow.tr)
                                  .paddingSymmetric(vertical: 22, horizontal: 15)
                            }
                          ],
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Padding(
                      //       padding: EdgeInsets.only(top: Get.height / 8.5, right: 8),
                      //       child: SizedBox(
                      //         width: 80,
                      //         height: 240,
                      //         child: ListView.builder(
                      //           physics: const BouncingScrollPhysics(),
                      //           itemCount: userProductDetailsController.userProductDetails!.product?[0].images!.length,
                      //           itemBuilder: (context, index) {
                      //             return Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: GestureDetector(
                      //                 onTap: () {
                      //                   setState(() {});
                      //                   click = index;
                      //                   productController.jumpToPage(index);
                      //                 },
                      //                 child: Container(
                      //                   height: 65,
                      //                   width: 65,
                      //                   decoration: BoxDecoration(
                      //                       border: Border.all(width: 2, color: click1 == index ? AppColors.primaryPink : Colors.transparent),
                      //                       borderRadius: BorderRadius.circular(12)),
                      //                   child: ClipRRect(
                      //                     borderRadius: BorderRadius.circular(10),
                      //                     child: CachedNetworkImage(
                      //                       height: 65,
                      //                       width: 65,
                      //                       fit: BoxFit.cover,
                      //                       imageUrl: userProductDetailsController.userProductDetails!.product![0].images![index].toString(),
                      //                       placeholder: (context, url) => const Center(
                      //                           child: CupertinoActivityIndicator(
                      //                         radius: 7,
                      //                         animating: true,
                      //                       )),
                      //                       errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       )),
                      // ),
                      // Align(
                      //   alignment: Alignment.topCenter,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(top: Get.height / 2.4 + 3),
                      //     child: Container(
                      //       height: Get.height / 11,
                      //       color: Colors.transparent,
                      //       child: Center(
                      //         child: SmoothPageIndicator(
                      //           effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primaryPink),
                      //           controller: productController,
                      //           count: userProductDetailsController.userProductDetails!.product![0].images!.length.toInt(),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            /* bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(15.0),
              child: HorizontalSlidableButton(
                height: 60,
                width: MediaQuery.of(context).size.width,
                buttonWidth: 60.0,
                color: Colors.white,
                buttonColor: AppColors.primary,
                dismissible: false,
                label: Center(
                  child: Image.asset(AppAsset.icCart, width: 22, color: AppColors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          St.addToCartThisProduct.tr.toUpperCase(),
                          style: AppFontStyle.styleW700(AppColors.black, 15),
                        ),
                        10.width,
                        Image.asset(AppAsset.icDoubleArrowRight, width: 14, color: AppColors.black),
                      ],
                    ),
                  ),
                ),
                onChanged: (position) async {
                  if (position == SlidableButtonPosition.end) {
                    if (addProductToCartController.isAddToCart.isFalse) {
                      if (areAllAttributesFilled != true) {
                        displayToast(message: St.pleaseFillAllAttributes.tr);
                      } else {
                        await addToCart();
                        if (addProductToCartController.addProductToCart?.status == true) {
                          Get.dialog(Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPink,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        St.addToCart.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Image.asset("assets/icons/add-to-shopping-cart2.png", height: 200).paddingSymmetric(vertical: 8),
                                  Text(
                                    St.congratulationYourOrderHasBeenDelivered.tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: AppColors.darkGrey,
                                    ),
                                  ).paddingSymmetric(horizontal: 15),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 50,
                                      width: Get.width / 2,
                                      decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                                      child: Center(
                                        child: Text(
                                          St.remove.tr,
                                          style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ).paddingSymmetric(vertical: 15)
                                ],
                              ),
                            ),
                          ));
                        } else {
                          Get.dialog(Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPink,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        St.addToCart.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Image.asset("assets/icons/add-to-shopping-cart2.png", height: 200).paddingSymmetric(vertical: 8),
                                  Text(
                                    St.onlyOneSellersProductsAddedToCartAtATimeCanWeRemoveIt.tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: AppColors.darkGrey,
                                    ),
                                  ).paddingSymmetric(horizontal: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => removeAllProductFromCartController.deleteAllCartProduct().then((value) => Get.back()).then((value) => addToCart()),
                                        child: Container(
                                          height: 50,
                                          width: Get.width / 3,
                                          decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text(
                                              St.remove.tr,
                                              style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ).paddingOnly(right: 13),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: Get.width / 3,
                                          decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text(
                                              St.cancelSmallText.tr,
                                              style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 15)
                                ],
                              ),
                            ),
                          ));
                        }
                      }
                    } else {
                      Get.offAll(BottomTabBar(
                        index: 3,
                      ));
                    }
                  }
                },
              ),
            ),*/
          ),
        ],
      ),
    );
  }

  Widget rattingBottomSheet() {
    return Container(
      height: Get.height / 1.8,
      decoration: BoxDecoration(color: AppColors.black, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
      child: Stack(
        children: [
          Column(
            children: [
              RatingBar.builder(
                itemPadding: const EdgeInsets.only(),
                ignoreGestures: false,
                glow: false,
                unratedColor: const Color(0xffE3E9ED),
                itemSize: 45,
                initialRating: 4.0,
                minRating: 1,
                maxRating: 5,
                glowRadius: 10,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  size: 50,
                  color: Color(0xffF0BB52),
                ),
                onRatingUpdate: (rating) {
                  createRatingController.rating.value = rating.toDouble();
                  log("Selected Rating :: ${createRatingController.rating.value}");
                },
              ).paddingOnly(top: 90, bottom: 25),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    St.detailReview.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: createReviewController.detailsReviewController,
                textInputAction: TextInputAction.done,
                maxLines: 7,
                minLines: 5,
                style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.tabBackground,
                  enabledBorder: OutlineInputBorder(borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(24)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26)),
                  hintText: St.theProductIsVeryGoodAndCorrespondsToThePicture.tr,
                  hintStyle: GoogleFonts.plusJakartaSans(height: 1.6, color: Colors.grey.shade600, fontSize: 15),
                ),
              ),
              const Spacer(),
              PrimaryPinkButton(
                      onTaped: () {
                        Get.back();
                        createReviewController.postReviewData();
                        createRatingController.postRatingData();
                      },
                      text: St.submit.tr)
                  .paddingSymmetric(vertical: 15),
            ],
          ).paddingSymmetric(horizontal: 20),
          Container(
            height: 90,
            width: Get.width,
            decoration: BoxDecoration(color: AppColors.black, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    St.giveReview.tr,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.white,
                      fontSize: 19.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: PrimaryRoundButton(
                      onTaped: () {
                        Get.back();
                      },
                      icon: Icons.close,
                      iconColor: AppColors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
