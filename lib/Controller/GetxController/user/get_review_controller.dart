import 'dart:developer';

import 'package:era_shop/ApiModel/user/GetReviewModel.dart';
import 'package:era_shop/ApiService/user/get_review_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

class GetReviewController extends GetxController {
  GetReviewModel? getReview;
  RxBool isLoading = true.obs;
  getReviewDetails() async {
    try {
      isLoading(true);
      var data = await GetReviewApi().getReviewDetails(productId: productId);
      getReview = data;
    } catch (e) {
      // Exception handling code
      log('New Collection Error: $e');
    } finally {
      isLoading(false);
      log('Get Review Details finally');
    }
  }
}
