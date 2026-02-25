import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/seller/PendingOrderAmountModel.dart';
import '../../../ApiService/seller/seller_wallet_pending_amount_service.dart';

class SellerWalletPendingAmountController extends GetxController {
  PendingOrderAmountModel? pendingOrderAmount;
  RxBool isLoading = false.obs;

  sellerWalletPendingAmountData() async {
    try {
      isLoading(true);
      var data = await SellerWalletPendingAmountApi().sellerWalletPendingAmountDetails();
      pendingOrderAmount = data;
    } catch (e) {
      // Exception handling code
      log('Seller Wallet Pending Amount Error: $e');
    } finally {
      isLoading(false);
      log('finally ${pendingOrderAmount?.message}');
    }
  }
}
