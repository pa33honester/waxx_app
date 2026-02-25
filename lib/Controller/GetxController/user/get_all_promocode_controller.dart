import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ApiModel/user/GetAllPromoCodeModel.dart';
import '../../../ApiService/user/get_all_promocode_service.dart';

class GetAllPromoCodeController extends GetxController {
  RxBool isLoading = true.obs;
  GetAllPromoCodeModel? getAllPromoCode;

  final TextEditingController promoCodeController = TextEditingController();

  String selectedPromoCodeId="";

  Future getAllPromoCodes() async {
    try {
      isLoading(true);
      var data = await GetAllPromoCodeApi().showAllPromoCode();
      getAllPromoCode = data;
    } catch (e) {
      log('Get All promocode error: $e');
    } finally {
      isLoading(false);
      log('Get All promo Code Finally');
    }
  }
}
