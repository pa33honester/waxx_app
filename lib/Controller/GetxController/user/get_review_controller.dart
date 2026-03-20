import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetReviewModel.dart';
import 'package:waxxapp/ApiService/user/get_review_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
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
