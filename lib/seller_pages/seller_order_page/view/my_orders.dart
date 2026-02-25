import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:era_shop/Controller/GetxController/seller/seller_order_count_controller.dart';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/CancelledOrder/cancelled_order.dart';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/ConfirmedOrders/confirmed_orders.dart';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/DeliveredOrder/delivered_order.dart';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/OutOfDeliveryOrders/out_of_delivery_orders.dart';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/PendingOrder/pending_orders.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  // String? pendingOrder;
  // String? confirmedOrders;
  // String? deliveredOrder;
  // String? outOfDeliveredOrder;
  // String? cancelOrder;
  // String? totalOrder;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? errorText;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateRangePickerController rangePickerController = DateRangePickerController();
    PickerDateRange? initialRange;

    if (selectedStartDate != null && selectedEndDate != null) {
      // Previously selected dates use કરો
      initialRange = PickerDateRange(selectedStartDate, selectedEndDate);
    } else {
      // Default range use કરો
      initialRange = PickerDateRange(
        DateTime.now().subtract(const Duration(days: 31)),
        DateTime.now(),
      );
    }

    PickerDateRange _getInitialDateRange() {
      if (selectedStartDate != null && selectedEndDate != null) {
        return PickerDateRange(selectedStartDate, selectedEndDate);
      } else {
        final defaultStart = DateTime.now().subtract(const Duration(days: 31));
        final defaultEnd = DateTime.now();

        selectedStartDate = defaultStart;
        selectedEndDate = defaultEnd;

        return PickerDateRange(defaultStart, defaultEnd);
      }
    }

    String getFormattedDateRange() {
      if (selectedStartDate != null && selectedEndDate != null) {
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        return '${formatter.format(selectedStartDate!)} - ${formatter.format(selectedEndDate!)}';
      } else {
        return 'Select Date Range';
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: AppColors.tabBackground,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.darkGrey,
              onSurface: Colors.white,
            ),
            dividerColor: Colors.white54,
          ),
          child: AlertDialog(
            backgroundColor: AppColors.tabBackground,
            title: Text(
              St.selectDateRange.tr,
              style: TextStyle(color: AppColors.white),
            ),
            content: SizedBox(
              height: 300,
              width: 300,
              child: SfDateRangePicker(
                controller: rangePickerController,
                initialSelectedRange: initialRange,
                minDate: DateTime(2020, 01, 01),
                maxDate: DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.range,
                // initialSelectedRange: PickerDateRange(
                //   DateTime.now().subtract(const Duration(days: 31)),
                //   DateTime.now(),
                // ),
                selectionTextStyle: TextStyle(color: AppColors.black),
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: AppColors.tabBackground,
                    textStyle: TextStyle(
                      color: Colors.white,
                    )),
                backgroundColor: AppColors.tabBackground,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    if (args.value is PickerDateRange) {
                      selectedStartDate = args.value.startDate;
                      selectedEndDate = args.value.endDate;
                      errorText = null; // Reset error message
                    }
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text('OK',
                    style: TextStyle(
                      color: AppColors.black,
                    )),
                onPressed: () {
                  if (selectedStartDate == null || selectedEndDate == null) {
                    Utils.showToast(St.pleaseSelectBothStartAndEndDates.tr);
                    // setState(() {
                    //   errorText = St.pleaseSelectBothStartAndEndDates.tr;
                    // });
                  } else if (selectedStartDate!.isAfter(selectedEndDate!)) {
                    Utils.showToast(St.startDateCanNotBeAfterEndDate.tr);
                    // setState(() {
                    //   errorText = St.startDateCanNotBeAfterEndDate.tr;
                    // });
                  } else {
                    _callAPI();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getFormattedDateRange() {
    if (selectedStartDate == null || selectedEndDate == null) {
      return St.selectDateRange.tr;
    }

    final startFormat = DateFormat('MMM dd, yyyy');
    final endFormat = DateFormat('MMM dd, yyyy');

    return "${startFormat.format(selectedStartDate!)} - ${endFormat.format(selectedEndDate!)}";
  }

  Future<void> _callAPI() async {
    if (selectedStartDate != null && selectedEndDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String startDateString = formatter.format(selectedStartDate!);
      final String endDateString = formatter.format(selectedEndDate!);
      log('Start Date: $startDateString');
      log('End Date: $endDateString');
      sellerMyOrderCountController.sellerMyOrderCountData(startDate: selectedStartDate.toString(), endDate: selectedEndDate.toString());
      setState(() {});
    }
  }

  SellerCommonController sellerController = Get.put(SellerCommonController());
  SellerOrderCountController sellerMyOrderCountController = Get.put(SellerOrderCountController());
  DateTime start = DateTime.now().subtract(const Duration(days: 30));
  DateTime end = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    sellerMyOrderCountController.sellerMyOrderCountData(startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
    // pendingOrder = sellerMyOrderCountController.sellerMyOrderCount?.pendingOrders.toString();
    // confirmedOrders = sellerMyOrderCountController.sellerMyOrderCount?.confirmedOrders.toString();
    // deliveredOrder = sellerMyOrderCountController.sellerMyOrderCount?.deliveredOrders.toString();
    // cancelOrder = sellerMyOrderCountController.sellerMyOrderCount?.cancelledOrders.toString();
    // totalOrder = sellerMyOrderCountController.sellerMyOrderCount?.totalOrders.toString();
    // outOfDeliveredOrder = sellerMyOrderCountController.sellerMyOrderCount?.outOfDeliveryOrders.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.myOrder.tr),
          ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(
            () => sellerMyOrderCountController.isLoading.value
                ? Shimmers.sellerMyOrderShimmer()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 16),
                      // if (errorText != null)
                      //   Text(
                      //     errorText!,
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      // if (selectedStartDate != null && selectedEndDate != null)
                      //   Text(
                      //     'Selected Date Range: ${selectedStartDate.toString()} - ${selectedEndDate.toString()}',
                      //     style: TextStyle(fontSize: 16),
                      //   ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              St.selectDate.tr,
                              style: AppFontStyle.styleW700(AppColors.white, 18),
                            ),
                            // SmallTitle(title: St.selectDate.tr),
                            MainButtonWidget(
                              height: 36,
                              // width: 170,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              color: AppColors.primary,
                              borderRadius: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getFormattedDateRange(),
                                    style: AppFontStyle.styleW700(AppColors.black, 12),
                                  ),
                                  5.width,
                                  Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.black, size: 20),
                                ],
                              ),
                              callback: () => _selectDateRange(context),
                            ),
                            // ElevatedButton(
                            //   style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.primaryPink), elevation: const WidgetStatePropertyAll(0)),
                            //   onPressed: () => _selectDateRange(context),
                            //   child: Text(St.selectDateRange.tr),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.tabBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: Get.width,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                St.orderList.tr,
                                style: AppFontStyle.styleW700(AppColors.primary, 14),
                              ),
                            ),
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                            OrderListTileWidget(
                              title: St.pendingOrder.tr,
                              orderCount: "${sellerMyOrderCountController.sellerMyOrderCount!.pendingOrders}",
                              callback: () {
                                Get.to(
                                        () => PendingOrders(
                                              status: "Pending",
                                              endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                                              startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                                            ),
                                        transition: Transition.rightToLeft)
                                    ?.then((value) {
                                  sellerMyOrderCountController.sellerMyOrderCountData(
                                      startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                                });
                              },
                            ),
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                            OrderListTileWidget(
                              title: St.confirmedOrders.tr,
                              orderCount: "${sellerMyOrderCountController.sellerMyOrderCount?.confirmedOrders}",
                              callback: () {
                                Get.to(
                                        () => ConfirmedOrders(
                                              status: "Confirmed",
                                              endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                                              startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                                            ),
                                        transition: Transition.rightToLeft)
                                    ?.then((value) {
                                  sellerMyOrderCountController.sellerMyOrderCountData(
                                      startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                                });
                              },
                            ),
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                            OrderListTileWidget(
                              title: St.outOfDeliveredOrder.tr,
                              orderCount: "${sellerMyOrderCountController.sellerMyOrderCount?.outOfDeliveryOrders}",
                              callback: () {
                                Get.to(
                                        () => OutOfDeliveryOrders(
                                              status: "Out Of Delivery",
                                              endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                                              startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                                            ),
                                        transition: Transition.rightToLeft)
                                    ?.then((value) {
                                  sellerMyOrderCountController.sellerMyOrderCountData(
                                      startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                                });
                              },
                            ),
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                            OrderListTileWidget(
                              title: St.deliveredOrder.tr,
                              orderCount: "${sellerMyOrderCountController.sellerMyOrderCount?.deliveredOrders}",
                              callback: () {
                                Get.to(
                                        () => DeliveredOrder(
                                              status: "Delivered",
                                              endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                                              startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                                            ),
                                        transition: Transition.rightToLeft)
                                    ?.then((value) {
                                  sellerMyOrderCountController.sellerMyOrderCountData(
                                      startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                                });
                              },
                            ),
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.2)),
                            OrderListTileWidget(
                              title: St.cancelOrder.tr,
                              orderCount: "${sellerMyOrderCountController.sellerMyOrderCount?.cancelledOrders}",
                              callback: () {
                                Get.to(
                                        () => CancelledOrder(
                                              status: "Cancelled",
                                              endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                                              startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                                            ),
                                        transition: Transition.rightToLeft)
                                    ?.then((value) {
                                  sellerMyOrderCountController.sellerMyOrderCountData(
                                      startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(), endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                                });
                              },
                            ),
                          ],
                        ),
                      ).paddingAll(16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.tabBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              St.totalOrder.tr,
                              style: AppFontStyle.styleW500(AppColors.white, 14),
                            ),
                            const Spacer(),
                            Text(
                              "${sellerMyOrderCountController.sellerMyOrderCount?.totalOrders}",
                              style: AppFontStyle.styleW700(AppColors.primary, 14),
                            ),
                            10.width,
                          ],
                        ),
                      ).paddingAll(16),
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.to(
                      //             () => PendingOrders(
                      //                   status: "Pending",
                      //                   endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                      //                   startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //                 ),
                      //             transition: Transition.rightToLeft)
                      //         ?.then((value) {
                      //       sellerMyOrderCountController.sellerMyOrderCountData(
                      //           startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //           endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.pendingOrder.tr),
                      //           const Spacer(),
                      //           Text(
                      //               // pendingOrder == null
                      //               //     ? "${sellerMyOrderCountController.sellerMyOrderCount!.pendingOrders}"
                      //               //     : "$pendingOrder",
                      //               "${sellerMyOrderCountController.sellerMyOrderCount!.pendingOrders}",
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
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.to(
                      //             () => ConfirmedOrders(
                      //                   status: "Confirmed",
                      //                   endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                      //                   startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //                 ),
                      //             transition: Transition.rightToLeft)
                      //         ?.then((value) {
                      //       sellerMyOrderCountController.sellerMyOrderCountData(
                      //           startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //           endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.confirmedOrders.tr),
                      //           const Spacer(),
                      //           Text(
                      //               // confirmedOrders == null
                      //               //     ? "${sellerMyOrderCountController.sellerMyOrderCount?.confirmedOrders}"
                      //               //     : "$confirmedOrders",
                      //               "${sellerMyOrderCountController.sellerMyOrderCount?.confirmedOrders}",
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
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.to(
                      //             () => OutOfDeliveryOrders(
                      //                   status: "Out Of Delivery",
                      //                   endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                      //                   startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //                 ),
                      //             transition: Transition.rightToLeft)
                      //         ?.then((value) {
                      //       sellerMyOrderCountController.sellerMyOrderCountData(
                      //           startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //           endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.outOfDeliveredOrder.tr),
                      //           const Spacer(),
                      //           Text(
                      //               // outOfDeliveredOrder == null
                      //               //     ? "${sellerMyOrderCountController.sellerMyOrderCount?.outOfDeliveryOrders}"
                      //               //     : "$outOfDeliveredOrder",
                      //               "${sellerMyOrderCountController.sellerMyOrderCount?.outOfDeliveryOrders}",
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
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.to(
                      //             () => DeliveredOrder(
                      //                   status: "Delivered",
                      //                   endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                      //                   startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //                 ),
                      //             transition: Transition.rightToLeft)
                      //         ?.then((value) {
                      //       sellerMyOrderCountController.sellerMyOrderCountData(
                      //           startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //           endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.deliveredOrder.tr),
                      //           const Spacer(),
                      //           Text(
                      //               // deliveredOrder == null
                      //               //     ? "${sellerMyOrderCountController.sellerMyOrderCount?.deliveredOrders}"
                      //               //     : "$deliveredOrder",
                      //               "${sellerMyOrderCountController.sellerMyOrderCount?.deliveredOrders}",
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
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () {
                      //     Get.to(
                      //             () => CancelledOrder(
                      //                   status: "Cancelled",
                      //                   endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString(),
                      //                   startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //                 ),
                      //             transition: Transition.rightToLeft)
                      //         ?.then((value) {
                      //       sellerMyOrderCountController.sellerMyOrderCountData(
                      //           startDate: selectedStartDate != null ? selectedStartDate.toString() : start.toString(),
                      //           endDate: selectedEndDate != null ? selectedEndDate.toString() : end.toString());
                      //     });
                      //   },
                      //   child: SizedBox(
                      //     height: 65,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       child: Row(
                      //         children: [
                      //           SmallTitle(title: St.cancelOrder.tr),
                      //           const Spacer(),
                      //           Text(
                      //               // cancelOrder == null
                      //               //     ? "${sellerMyOrderCountController.sellerMyOrderCount?.cancelledOrders}"
                      //               //     : "$cancelOrder",
                      //               "${sellerMyOrderCountController.sellerMyOrderCount?.cancelledOrders}",
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
                      // SizedBox(
                      //   height: 65,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 15),
                      //     child: Row(
                      //       children: [
                      //         SmallTitle(title: St.totalOrder.tr),
                      //         const Spacer(),
                      //         Text(
                      //             // totalOrder == null
                      //             //     ? "${sellerMyOrderCountController.sellerMyOrderCount?.totalOrders}"
                      //             //     : "$totalOrder",
                      //             "${sellerMyOrderCountController.sellerMyOrderCount?.totalOrders}",
                      //             style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 16, fontWeight: FontWeight.w700)),
                      //         const SizedBox(
                      //           width: 34,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   height: 0,
                      //   color: AppColors.mediumGrey,
                      // ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class OrderListTileWidget extends StatelessWidget {
  const OrderListTileWidget({super.key, required this.title, required this.orderCount, required this.callback});

  final String title;
  final String orderCount;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: AppColors.transparent,
        height: 60,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFontStyle.styleW500(AppColors.white, 14),
            ),
            const Spacer(),
            Text(
              orderCount,
              style: AppFontStyle.styleW700(AppColors.primary, 14),
            ),
            15.width,
            Image.asset(AppAsset.icArrowRight, width: 8, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
