import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../ApiModel/login/user_sand_otp_model.dart';

class UserVerifyOtpService extends GetxService {
  Future<UserSandOtpModel> sandOtp({
    required String email,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.userLoginVerifyOtp);

    print('URL :: $url');

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final body = jsonEncode({
      'email': email,
    });
    final response = await http.post(url, body: body, headers: headers);

    print('BODY :: $body');

    log("User verify OTP response :: ${response.statusCode}");
    log(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return UserSandOtpModel.fromJson(jsonResponse);
    } else {
      throw Exception('User verify OTP Failed');
    }
  }
}
