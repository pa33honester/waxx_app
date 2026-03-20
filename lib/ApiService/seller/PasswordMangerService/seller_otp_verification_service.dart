import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/login/VerifyOtpModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

class SellerOtpVerifyService extends GetxService {
  Future<VerifyOtpModel?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.otpVerify);

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final body = jsonEncode({
      'email': email,
      'otp': otp,
    });

    final response = await http.post(url, headers: headers, body: body);

    log("Enter OTP Status code :: ${response.statusCode}");

    log(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return VerifyOtpModel.fromJson(jsonResponse);
    } else {
      throw Exception('Otp api Failed');
    }
  }
}
