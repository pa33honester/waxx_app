import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ApiModel/user/CreateReviewModel.dart';
import '../../../ApiService/user/create_review_service.dart';
import '../../../utils/globle_veriables.dart';

class CreateReviewController extends GetxController {
  CreateReviewModel? createReview;
  RxBool isLoading = false.obs;
  TextEditingController detailsReviewController = TextEditingController();
  postReviewData() async {
    try {
      isLoading(true);
      var data = await ReviewApi().enterReview(review: detailsReviewController.text, userId: loginUserId, productId: productId);
      createReview = data;
      // if (createReview!.status == true) {
      //   Fluttertoast.showToast(
      //       msg: "Your review submitted \nsuccessfully",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 2,
      //       backgroundColor: AppColors.primaryPink,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // } else {
      //   Fluttertoast.showToast(
      //       msg: "you have already given review \non this product!!",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 2,
      //       backgroundColor: AppColors.primaryPink,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
    } finally {
      isLoading(false);
      log('Review Api Response');
    }
  }
}
