import 'dart:io';

import 'package:waxxapp/ApiModel/seller/SellerLoginModel.dart';
import 'package:waxxapp/ApiService/seller/seller_login_service.dart';

import 'package:get/get.dart';

class SellerLoginController extends GetxController {
  SellerLoginModel? sellerLogin;
  var isLoading = true.obs;
  getSellerLoginData({
    required String userId,
    required String storeName,
    required String businessTag,
    required String mobileNumber,
    required String countryCode,
    required String email,
    required String password,
    required String address,
    required String landMark,
    required String city,
    required String pinCode,
    required String state,
    required String country,
    required String bankBusinessName,
    required String bankName,
    required String accountNumber,
    required String IFSCCode,
    required String branchName,
    required String businessType,
    required String category,
    required String description,
    required File logo,
    required List<File> govId,
    required List<File> registrationCert,
    required List<File> addressProof,
  }) async {
    try {
      isLoading(true);
      var data = await SellerLoginApi().sellerLogin(
        userId: userId,
        storeName: storeName,
        businessTag: businessTag,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
        email: email,
        password: password,
        address: address,
        landMark: landMark,
        city: city,
        pinCode: pinCode,
        state: state,
        country: country,
        bankBusinessName: bankBusinessName,
        bankName: bankName,
        accountNumber: accountNumber,
        IFSCCode: IFSCCode,
        branchName: branchName,
        businessType: businessType,
        category: category,
        description: description,
        logo: logo,
        govId: govId,
        registrationCert: registrationCert,
        addressProof: addressProof,
      );
      sellerLogin = data;
    } finally {
      isLoading(false);
    }
  }
}
