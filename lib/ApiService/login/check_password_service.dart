import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/ApiModel/login/check_password_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CheckPasswordService extends GetxService {
  Future<CheckPasswordModel?> checkPassword({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.checkPassword);

    log("email ::: $email");
    log("password ::: $password");

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final response = await http.post(url, headers: headers, body: body);

    log("Check Password Status code :: ${response.statusCode} Response Body :: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CheckPasswordModel.fromJson(jsonResponse);
    } else {
      throw Exception('Check Password');
    }
  }
}
