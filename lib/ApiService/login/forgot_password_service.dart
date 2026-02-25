import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:era_shop/ApiModel/login/ForgotPasswordModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';

class ForgotPasswordApi extends GetxService {
  Future<ForgotPasswordModel> forgotPassword({
    required String email,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.otpCreate);

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final body = jsonEncode({
      'email': email,
    });
    final response = await http.post(url, body: body, headers: headers);

    log("Create otp response :: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ForgotPasswordModel.fromJson(jsonResponse);
    } else {
      throw Exception('Email api Failed');
    }
  }
}
