import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/seller/SellerAllWalletAmountCountModel.dart';
import '../../../ApiService/seller/seller_all_wallet_amount_count_service.dart';

class SellerAllWalletAmountCountController extends GetxController {
  SellerAllWalletAmountCountModel? sellerAllWalletAmount;
  RxBool isLoading = false.obs;

  sellerMyOrderCountData() async {
    try {
      isLoading(true);
      var data = await SellerAllWalletAmountCountApi().sellerAllWalletAmountCountDetails();
      sellerAllWalletAmount = data;
    } catch (e) {
      // Exception handling code
      log('Seller All Wallet Amount Error: $e');
    } finally {
      isLoading(false);
      log('finally ${sellerAllWalletAmount?.message}');
    }
  }
}
