import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/UserAddressSelectModel.dart';
import '../../utils/api_url.dart';
import '../../utils/globle_veriables.dart';

class GetOnlySelectedUserAddressApi extends GetxService {
  Future<UserAddressSelectModel?> getOnlySelectedAddress() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {"userId": userId};
    // final url = Uri.https(uri, Api.getOnlySelectedAddress, params);
    final url = Uri.parse("${Api.baseUrl + Api.getOnlySelectedAddress}?userId=$loginUserId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('Only Selected User Address Api URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserAddressSelectModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
