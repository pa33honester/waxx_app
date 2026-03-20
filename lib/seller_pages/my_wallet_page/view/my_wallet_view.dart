import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/GetxController/seller/seller_all_wallet_amount_count_controller.dart';

class MyWalletView extends StatefulWidget {
  const MyWalletView({super.key});

  @override
  State<MyWalletView> createState() => _MyWalletViewState();
}

class _MyWalletViewState extends State<MyWalletView> with TickerProviderStateMixin {
  SellerCommonController sellerController = Get.put(SellerCommonController());
  SellerAllWalletAmountCountController sellerAllWalletAmountCountController = Get.put(SellerAllWalletAmountCountController());

  // Pick date code
  // var showOrderDate = "";

  // DateTime? selectedStartDate;
  // DateTime? selectedEndDate;
  // String? errorText;

  // Future<void> _selectDateRange(BuildContext context) async {
  //   final DateRangePickerController rangePickerController = DateRangePickerController();
  //
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Select Date Range'),
  //         content: SizedBox(
  //           height: 300,
  //           width: 300,
  //           child: SfDateRangePicker(
  //             controller: rangePickerController,
  //             minDate: DateTime(2020, 01, 01),
  //             maxDate: DateTime.now(),
  //             selectionMode: DateRangePickerSelectionMode.range,
  //             initialSelectedRange: PickerDateRange(
  //               DateTime.now().subtract(const Duration(days: 31)),
  //               DateTime.now(),
  //             ),
  //             onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
  //               setState(() {
  //                 if (args.value is PickerDateRange) {
  //                   selectedStartDate = args.value.startDate;
  //                   selectedEndDate = args.value.endDate;
  //                   errorText = null; // Reset error message
  //                 }
  //               });
  //             },
  //           ),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               if (selectedStartDate == null || selectedEndDate == null) {
  //                 setState(() {
  //                   errorText = 'Please select both start and end dates';
  //                 });
  //               } else if (selectedStartDate!.isAfter(selectedEndDate!)) {
  //                 setState(() {
  //                   errorText = 'Start date cannot be after end date';
  //                 });
  //               } else {
  //                 _callAPI();
  //                 // sellerMyOrderCountController.sellerMyOrderCountData(
  //                 //     startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
  //                 //     endDate: selectedEndDate != null ? selectedEndDate.toString() :end.toString() );
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _callAPI() async {
  //   final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //   final String startDateString = formatter.format(selectedStartDate!);
  //   final String endDateString = formatter.format(selectedEndDate!);
  //   print('Start Date: $startDateString');
  //   print('End Date: $endDateString');
  //
  //   sellerAllWalletAmountCountController.sellerMyOrderCountData(
  //       startDate: selectedStartDate.toString(), endDate: selectedEndDate.toString());
  //   // TODO: Call your API
  //   // Perform API call here and wait for the response
  //
  //   // After API call is complete, refresh the page
  //   setState(() {
  //     // Update any necessary variables or UI elements
  //     // to reflect the new data from the API response
  //   });
  // }

  // DateTime start = DateTime.now().subtract(const Duration(days: 30));
  // DateTime end = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sellerAllWalletAmountCountController.sellerMyOrderCountData();
  }

  @override
  Widget build(BuildContext context) {
    Utils.onChangeSystemColor();
    return CustomColorBgWidget(
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.transparent,
                shadowColor: AppColors.black.withValues(alpha: 0.4),
                flexibleSpace: SimpleAppBarWidget(title: St.myWallet.tr),
              ),
            ),
            body: Obx(() {
              if (sellerAllWalletAmountCountController.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primary,
                ));
              } else {
                var walletAllAmount = sellerAllWalletAmountCountController.sellerAllWalletAmount;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.height,
                      GestureDetector(
                        onTap: () => Get.toNamed("/TotalEarning"),
                        child: Container(
                          height: 130,
                          width: Get.width,
                          clipBehavior: Clip.antiAlias,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(image: AssetImage(AppAsset.imgWallet_1), fit: BoxFit.cover),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                St.totalEarning.tr,
                                style: AppFontStyle.styleW700(AppColors.black, 12),
                              ),
                              3.height,
                              Text(
                                "${walletAllAmount?.earningAmount ?? 0}",
                                style: AppFontStyle.styleW900(AppColors.black, 28),
                              ),
                              5.height,
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    clipBehavior: Clip.antiAlias,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Pending Amount :  $currencySymbol ${walletAllAmount?.pendingAmount ?? 0}",
                                      style: AppFontStyle.styleW700(AppColors.white, 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      15.height,
                      Container(
                        height: 130,
                        width: Get.width,
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(image: AssetImage(AppAsset.imgWallet_2), fit: BoxFit.cover),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              St.outstandingPayment.tr,
                              style: AppFontStyle.styleW700(AppColors.black, 12),
                            ),
                            3.height,
                            Text(
                              "$currencySymbol ${walletAllAmount?.pendingWithdrawbleRequestedAmount ?? 0}",
                              style: AppFontStyle.styleW900(AppColors.black, 28),
                            ),
                            5.height,
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  clipBehavior: Clip.antiAlias,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Next Payment Amount : $currencySymbol ${walletAllAmount?.pendingWithdrawbleRequestedAmount ?? 0}",
                                    style: AppFontStyle.styleW700(AppColors.white, 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      25.height,
                      // GestureDetector(
                      //   onTap: () => Get.toNamed("/TotalEarning"),
                      //   child: Container(
                      //     height: 96,
                      //     width: Get.width,
                      //     decoration: BoxDecoration(
                      //       color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                      //       border: Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha:0.30) : Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(10),
                      //       // color: Colors.grey,
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Text(
                      //           St.totalEarning.tr,
                      //           style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey, fontWeight: FontWeight.w600, fontSize: 15.5),
                      //         ),
                      //         Text(
                      //           "${walletAllAmount!.earningAmount}",
                      //           style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 27),
                      //         ),
                      //         // Divider(
                      //         //   height: 3,
                      //         //   color: AppColors.darkGrey.withValues(alpha:0.40),
                      //         // ),
                      //         // Text(
                      //         //   "Pending : ${walletAllAmount.sellerPendingAmount}",
                      //         //   style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15.5),
                      //         // ),
                      //       ],
                      //     ).paddingSymmetric(vertical: 15, horizontal: 12),
                      //   ).paddingSymmetric(horizontal: 15).paddingOnly(top: 15),
                      // ),
                      // Container(
                      //   height: 96,
                      //   width: Get.width,
                      //   decoration: BoxDecoration(
                      //     color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                      //     border: Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha:0.30) : Colors.grey.shade300),
                      //     borderRadius: BorderRadius.circular(10),
                      //     // color: Colors.grey,
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Text(
                      //         St.outstandingPayment.tr,
                      //         style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey, fontWeight: FontWeight.w600, fontSize: 15.5),
                      //       ),
                      //       Text(
                      //         "${walletAllAmount.pendingWithdrawbleRequestedAmount}",
                      //         style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 27),
                      //       ),
                      //       // Divider(
                      //       //   height: 3,
                      //       //   color: AppColors.darkGrey.withValues(alpha:0.40),
                      //       // ),
                      //       // Text(
                      //       //   "Next Payment : ${walletAllAmount.pendingWithdrawbleRequestedAmount}",
                      //       //   style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15.5),
                      //       // ),
                      //     ],
                      //   ).paddingSymmetric(vertical: 15, horizontal: 12),
                      // ).paddingSymmetric(horizontal: 15).paddingOnly(top: 12, bottom: 15),

                      Text(
                        "Payment",
                        style: AppFontStyle.styleW700(AppColors.white, 18),
                      ),
                      25.height,
                      GestureDetector(
                        onTap: () => Get.toNamed("/PaymentPending"),
                        child: Container(
                          color: AppColors.transparent,
                          child: Row(
                            children: [
                              Text(
                                St.pendingOrderAmount.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                              const Spacer(),
                              Text(
                                "${walletAllAmount?.pendingAmount}",
                                style: AppFontStyle.styleW700(AppColors.primary, 14),
                              ),
                              15.width,
                              Image.asset(AppAsset.icArrowRight, width: 8, color: AppColors.white),
                            ],
                          ),
                        ),
                      ),
                      15.height,
                      Divider(color: AppColors.unselected.withValues(alpha: 0.2)),
                      15.height,
                      GestureDetector(
                        onTap: () => Get.toNamed("/PaymentDeliveredAmount"),
                        child: Container(
                          color: AppColors.transparent,
                          child: Row(
                            children: [
                              Text(
                                St.deliveredOrderAmount.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                              const Spacer(),
                              Text(
                                "${walletAllAmount?.pendingWithdrawbleAmount}",
                                style: AppFontStyle.styleW700(AppColors.primary, 14),
                              ),
                              15.width,
                              Image.asset(AppAsset.icArrowRight, width: 8, color: AppColors.white),
                            ],
                          ),
                        ),
                      ),
                      15.height,
                      Divider(color: AppColors.unselected.withValues(alpha: 0.2)),
                      15.height,

                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.toNamed("/PaymentPending");
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.pendingOrderAmount.tr),
                      //           const Spacer(),
                      //           Text("${walletAllAmount?.pendingAmount}", style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 16, fontWeight: FontWeight.w700)),
                      //           const SizedBox(
                      //             width: 10,
                      //           ),
                      //           Icon(
                      //             Icons.keyboard_arrow_right_rounded,
                      //             color: AppColors.mediumGrey,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   height: 0,
                      //   color: AppColors.mediumGrey,
                      // ),
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.toNamed("/PaymentDeliveredAmount");
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.deliveredOrderAmount.tr),
                      //           const Spacer(),
                      //           Text("${walletAllAmount?.pendingWithdrawbleAmount}",
                      //               style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 16, fontWeight: FontWeight.w700)),
                      //           const SizedBox(
                      //             width: 10,
                      //           ),
                      //           Icon(
                      //             Icons.keyboard_arrow_right_rounded,
                      //             color: AppColors.mediumGrey,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   height: 0,
                      //   color: AppColors.mediumGrey,
                      // ),
                    ],
                  ),
                );
              }
            }),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: MainButtonWidget(
            //     height: 60,
            //     width: Get.width,
            //     child: Text(
            //       "WITHDRAW AMOUNT",
            //       overflow: TextOverflow.ellipsis,
            //       maxLines: 1,
            //       style: AppFontStyle.styleW700(AppColors.black, 15),
            //     ),
            //     callback: () {},
            //   ),
            // ),
          ),
        );
      }),
    );
  }

  // Pick date code
  // DateTime? _selectedDate;
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       String formattedDate = DateFormat('MMMM yyyy').format(_selectedDate!);
  //       log("---------------------------$formattedDate");
  //       showOrderDate = sellerController.walletDatePick.text = formattedDate;
  //     });
  //   }
  // }
  //
  // sellerWalletDebit() {
  //   return ListView.builder(
  //     cacheExtent: 1000,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //     itemCount: 12,
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 9),
  //         child: Container(
  //           height: 70,
  //           width: double.maxFinite,
  //           decoration: BoxDecoration(
  //               color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite,
  //               borderRadius: BorderRadius.circular(12)),
  //           child: Row(
  //             children: [
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Container(
  //                 height: 46,
  //                 width: 46,
  //                 decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(12),
  //                   child: Image.asset("assets/icons/debit.png"),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 14,
  //               ),
  //               SizedBox(
  //                 height: 45,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "JMS Collection",
  //                       style: GoogleFonts.plusJakartaSans(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 17,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 2),
  //                       child: Text(
  //                         "Delivery Code : INV#21242",
  //                         style: GoogleFonts.plusJakartaSans(
  //                           color: AppColors.mediumGrey,
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Spacer(),
  //               Text(
  //                 r"$90",
  //                 style: GoogleFonts.plusJakartaSans(
  //                   fontWeight: FontWeight.w700,
  //                   color: AppColors.primaryPink,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 14,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
