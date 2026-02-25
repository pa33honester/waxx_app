import 'dart:developer';
import 'package:era_shop/ApiModel/login/ForgotPasswordModel.dart';
import 'package:era_shop/ApiService/login/forgot_password_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordModel? createOtp;
  RxBool isLoading = false.obs;

  getForgotPasswordData({
    required String email,
  }) async {
    try {
      isLoading(true);
      var data = await ForgotPasswordApi().forgotPassword(email: email);
      createOtp = data;
    } finally {
      isLoading(false);
      log("getForgotPasswordData finally");
    }
  }
}
