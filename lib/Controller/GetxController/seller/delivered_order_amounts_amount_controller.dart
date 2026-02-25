import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/seller/DeliveredOrderAmountModel.dart';
import '../../../ApiService/seller/delivered_order_amount_service.dart';

class SellerWalletReceivedAmountController extends GetxController {
  DeliveredOrderAmountModel? deliveredOrderAmount;
  RxBool isLoading = true.obs;

  sellerWalletReceivedAmountData() async {
    try {
      isLoading(true);
      var data = await DeliveredOrderAmountService().sellerWalletReceivedAmountDetails();
      deliveredOrderAmount = data;
    } catch (e) {
      // Exception handling code
      log('Seller Wallet Received Amount Error: $e');
    } finally {
      isLoading(false);
      log('finally ${deliveredOrderAmount?.message}');
    }
  }
}
