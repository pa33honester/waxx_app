import 'dart:developer';
import 'package:era_shop/ApiModel/user/MyOrdersModel.dart';
import 'package:era_shop/ApiService/user/my_order_serivice.dart';
import 'package:era_shop/user_pages/my_order_page/widget/cancelled_order_view.dart';
import 'package:era_shop/user_pages/my_order_page/widget/delivered_order_view.dart';
import 'package:era_shop/user_pages/my_order_page/widget/processing_order_view.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderController extends GetxController {
  MyOrdersModel? myOrdersData;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  late final TabController orderTabController;

  getProductDetails({String? selectCategory}) async {
    final tabIndex = orderTabController.index;
    try {
      log("tabIndex :: $tabIndex");
      log("userId :: $loginUserId");
      isLoading = true;

      // Updated status mapping to include new auction statuses
      String status = getStatusFromTabIndex(tabIndex);

      var data = await MyOrderApi().myOrderDetails(
        userId: loginUserId,
        status: status,
      );
      myOrdersData = data;
    } finally {
      isLoading = false;
      log('Seller product details finally');
    }
  }

  // Helper method to get status string from tab index
  String getStatusFromTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return "All";
      case 1:
        return "Pending";
      case 2:
        return "Confirmed";
      case 3:
        return "Out Of Delivery";
      case 4:
        return "Delivered";
      case 5:
        return "Cancelled";
      case 6:
        return "Manual Auction Pending Payment";
      case 7:
        return "Manual Auction Cancelled";
      case 8:
        return "Auction Pending Payment";
      case 9:
        return "Auction Cancelled";
      default:
        return "All";
    }
  }

  // Helper method to check if a status is auction-related
  bool isAuctionStatus(String? status) {
    return status != null && (
        status == "Manual Auction Pending Payment" ||
            status == "Manual Auction Cancelled" ||
            status == "Auction Pending Payment" ||
            status == "Auction Cancelled"
    );
  }

  // Helper method to check if a status is pending payment
  bool isPendingPaymentStatus(String? status) {
    return status != null && (
        status == "Manual Auction Pending Payment" ||
            status == "Auction Pending Payment"
    );
  }

  // Helper method to check if a status is cancelled
  bool isCancelledStatus(String? status) {
    return status != null && (
        status == "Cancelled" ||
            status == "Manual Auction Cancelled" ||
            status == "Auction Cancelled"
    );
  }

  List<String> categories = [St.processingText.tr, St.deliveredText.tr, St.cancelledText.tr];
  List<Widget> pages = [const ProcessingOrderView(), const DeliveredOrderView(), const CancelledOrderView()];

  int selectedTabIndex = 0;

  void onChangeTab(int value) {
    selectedTabIndex = value;
    update(["onChangeTab"]);
  }
}