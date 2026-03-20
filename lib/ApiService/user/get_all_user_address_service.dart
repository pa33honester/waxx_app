import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetAllUserAddressModel.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_url.dart';

class GetAllUserAddressApi extends GetxService {
  Future<GetAllUserAddressModel?> getAllAddress() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {"userId": userId};
    final url = Uri.parse("${Api.baseUrl + Api.getAllAddress}?userId=$loginUserId");
    // final url = Uri.https(uri, Api.getAllAddress, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('Get All User Address Api STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetAllUserAddressModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
