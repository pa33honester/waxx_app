import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/seller/SellerTotalEarningModel.dart';
import '../../../ApiService/seller/seller_wallet_withdraw_amount_service.dart';

class SellerTotalEarningController extends GetxController {
  SellerTotalEarningModel? sellerTotalEarning;
  RxBool isLoading = true.obs;

  sellerWalletTotalAmount() async {
    try {
      isLoading(true);
      var data = await SellerTotalEarningService().selleTotalEarning();
      sellerTotalEarning = data;
    } catch (e) {
      // Exception handling code
      log('Seller Wallet Pending Amount Error: $e');
    } finally {
      isLoading(false);
      log('finally ${sellerTotalEarning?.message}');
    }
  }
}
