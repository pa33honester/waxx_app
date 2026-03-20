import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/UserAddressSelectModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserAddressSelectApi extends GetxService {
  Future<UserAddressSelectModel> userSelectAddress({required String addressId}) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {"addressId": addressId, "userId": userId};

    // final url = Uri.https(uri, Api.userSelectAddress, params);
    final url = Uri.parse("${Api.baseUrl + Api.userSelectAddress}?addressId=$addressId&userId=$loginUserId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.patch(url, headers: headers);

    log('User Select Address URL :: $url \n API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserAddressSelectModel.fromJson(jsonResponse);
    } else {
      throw Exception('User Select Address is failed');
    }
  }
}
