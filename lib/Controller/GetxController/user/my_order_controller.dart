import 'dart:developer';
import 'package:waxxapp/ApiModel/user/MyOrdersModel.dart';
import 'package:waxxapp/ApiService/user/accept_delivery_service.dart';
import 'package:waxxapp/ApiService/user/my_order_serivice.dart';
import 'package:waxxapp/user_pages/my_order_page/widget/cancelled_order_view.dart';
import 'package:waxxapp/user_pages/my_order_page/widget/delivered_order_view.dart';
import 'package:waxxapp/user_pages/my_order_page/widget/processing_order_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
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
  // Tab order matches `categories` in my_order.dart:
  // 0:All 1:Pending 2:Confirmed 3:Out Of Delivery 4:Delivered 5:Complete 6:Cancelled ...
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
        return "Complete";
      case 6:
        return "Cancelled";
      case 7:
        return "Manual Auction Pending Payment";
      case 8:
        return "Manual Auction Cancelled";
      case 9:
        return "Auction Pending Payment";
      case 10:
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
            status == "Auction Cancelled" ||
            status == "Bundle Pending Payment"
    );
  }

  // Helper method to check if a status is pending payment
  bool isPendingPaymentStatus(String? status) {
    return status != null && (
        status == "Manual Auction Pending Payment" ||
            status == "Auction Pending Payment" ||
            status == "Bundle Pending Payment"
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

  // Buyer confirms an item was received. Out Of Delivery -> Delivered.
  // Wallet credit happens later, when admin marks Complete.
  bool _accepting = false;
  Future<void> acceptDelivery({required String orderId, required String itemId}) async {
    if (_accepting) return;
    _accepting = true;
    try {
      final result = await AcceptDeliveryService().acceptDelivery(orderId: orderId, itemId: itemId);
      await displayToast(message: result.message.isNotEmpty ? result.message : St.deliveryAccepted.tr);
      if (result.status) {
        await getProductDetails();
      }
    } catch (e) {
      log('acceptDelivery error: $e');
      await displayToast(message: 'Failed to accept delivery');
    } finally {
      _accepting = false;
    }
  }
}