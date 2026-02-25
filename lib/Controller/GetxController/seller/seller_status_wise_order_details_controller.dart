import 'dart:developer';

import 'package:era_shop/ApiService/seller/seller_status_wise_order_details_Service.dart';

import 'package:get/get.dart';

import '../../../ApiModel/seller/SellerStatusWiseOrderDetailsModel.dart';

class SellerStatusWiseOrderDetailsController extends GetxController {
  SellerStatusWiseOrderDetailsModel? sellerStatusWiseOrderDetails;
  RxBool isLoading = true.obs;

  sellerStatusWiseOrderDetailsData({
    required String status,
    required String startDate,
    required String endDate,
  }) async {
    try {
      isLoading(true);
      var data = await SellerStatusWiseOrderDetailsApi()
          .sellerStatusWiseOrderDetails(startDate: startDate, endDate: endDate, status: status);
      sellerStatusWiseOrderDetails = data;
    } catch (e) {
      log('Seller Status Wise Order Details Error: $e');
    } finally {
      isLoading(false);
      log('finally ${sellerStatusWiseOrderDetails?.message}');
    }
  }
}
