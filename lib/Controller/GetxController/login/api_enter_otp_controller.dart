import 'package:era_shop/ApiModel/login/VerifyOtpModel.dart';
import 'package:era_shop/ApiService/login/enter_otp_service.dart';
import 'package:get/get.dart';

class VerifyOtpController extends GetxController {
  VerifyOtpModel? verifyOtp;

  getVerifyOtpData({
    required String email,
    required String otp,
  }) async {
    try {
      var data = await EnterOtpApi().enterOtp(
        email: email,
        otp: otp,
      );
      verifyOtp = data;
    } catch (e) {
      return Exception(e);
    }
  }
}
