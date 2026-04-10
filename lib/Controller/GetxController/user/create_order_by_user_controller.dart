import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/CreateOrderByUserModel.dart';

class CreateOrderByUserController extends GetxController {
  RxBool isLoading = false.obs;
  bool isPromoApplied = false;
  int finalAmount = 0;
  int total = 0;

  CreateOrderByUserModel? createOrderByUserModel;
  RxString? promoCode = "".obs;

  postOrderData({
    required String paymentGateway,
    required String promoCode,
    required int finalTotal,
    required int paymentStatus,
  }) async {
    try {
      isLoading(true);
      // var data = await CreateOrderByUserApi.createOrderByUserApi(
      //     paymentGateway: paymentGateway, promoCode: promoCode, finalTotal: finalTotal, paymentStatus: paymentStatus);
      // createOrderByUserModel = data;
    } catch (e) {
      log('Check Out : $e');
    } finally {
      isLoading(false);
      log('Check Out Api Response');
    }
  }
}
