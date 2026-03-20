import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/SellerOrderCountModel.dart';
import 'package:waxxapp/ApiService/seller/seller_order_count_service.dart';
import 'package:get/get.dart';

class SellerOrderCountController extends GetxController {
  SellerMyOrderCountModel? sellerMyOrderCount;
  RxBool isLoading = true.obs;

  sellerMyOrderCountData({
    required String startDate,
    required String endDate,
  }) async {
    try {
      isLoading(true);
      var data = await SellerOrderCountApi().sellerMyOrderCountDetails(startDate: startDate, endDate: endDate);
      sellerMyOrderCount = data;
    } catch (e) {
      // Exception handling code
      log('Seller My Order Count Error: $e');
    } finally {
      isLoading(false);
      log('finally ${sellerMyOrderCount?.message}');
    }
  }
}
