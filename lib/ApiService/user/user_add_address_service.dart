import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/ApiModel/user/UserAddAddressModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserAddAddressApi extends GetxService {
  Future<UserAddAddressModel> userAddAddress({
    required String userId,
    required String name,
    required String country,
    required String state,
    required String city,
    required String zipCode,
    required String address,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.userAddAddress);

    final body = jsonEncode({
      'userId': userId,
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'address': address,
    });

    log("call <<<<<<<<<<$body");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserAddAddressModel.fromJson(jsonResponse);
    } else {
      throw Exception('User Add Address is failed');
    }
  }
}
