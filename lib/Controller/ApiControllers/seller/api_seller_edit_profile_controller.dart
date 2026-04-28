import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/SellerEditProfileModel.dart';
import 'package:waxxapp/ApiService/seller/seller_edit_profile_service.dart';
import 'package:get/get.dart';

class SellerEditController extends GetxController {
  SellerEditProfileModel? sellerEditProfileData;
  var isLoading = true.obs;

  getEditProfileData({
    required String businessName,
    required String businessTag,
    required String address,
    required String landMark,
    required String city,
    required String pinCode,
    required String state,
    required String country,
    required String bankName,
    required String momoNumber,
    required String networkName,
    required String momoName,
  }) async {
    try {
      log("$state Kenil 2");
      isLoading(true);
      update();
      var data = await SellerProfileEditApi().sellerProfileEdit(
          businessName: businessName,
          businessTag: businessTag,
          address: address,
          landMark: landMark,
          city: city,
          pinCode: pinCode,
          state: state,
          country: country,
          bankName: bankName,
          momoNumber: momoNumber,
          networkName: networkName,
          momoName: momoName);
      sellerEditProfileData = data;
      // if (sellerEditProfileData!.status == true) {
      //
      // }
    } finally {
      isLoading(false);
    }
  }
}
