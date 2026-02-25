import 'dart:developer';

import 'package:era_shop/ApiModel/seller/SellerEditProfileModel.dart';
import 'package:era_shop/ApiService/seller/seller_edit_profile_service.dart';
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
    required String accountNumber,
    required String IFSCCode,
    required String branchName,
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
          accountNumber: accountNumber,
          IFSCCode: IFSCCode,
          branchName: branchName);
      sellerEditProfileData = data;
      // if (sellerEditProfileData!.status == true) {
      //
      // }
    } finally {
      isLoading(false);
    }
  }
}
