import 'dart:developer';

import 'package:era_shop/ApiModel/login/CrateNewPasswordModel.dart';
import 'package:era_shop/ApiService/login/create_password_service.dart';
import 'package:get/get.dart';

class ApiCreatePasswordController extends GetxController {
  CrateNewPasswordModel? crateNewPassword;

  getNewPasswordData({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      log("Try Entry getVerifyOtp");
      var data = await CreatePasswordApi().createPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      crateNewPassword = data;
    } finally {
      log("getNewPasswordData finnaly, try not work");
    }
  }
}
