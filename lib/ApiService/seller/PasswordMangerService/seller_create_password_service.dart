import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/login/CrateNewPasswordModel.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

class SellerCreatePasswordApi extends GetxService {
  Future<CrateNewPasswordModel> createPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.sellerSetPassword);

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final body = jsonEncode({
      "email": email,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    });
    final response = await http.post(url, headers: headers, body: body);

    log("Create Password :: ${response.statusCode}");

    log(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CrateNewPasswordModel.fromJson(jsonResponse);
    } else {
      throw Exception('Create password Failed');
    }
  }
}
