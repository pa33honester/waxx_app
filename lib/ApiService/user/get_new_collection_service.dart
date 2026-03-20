import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetNewCollectionModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetNewCollectionApi extends GetxService {
  Future<GetNewCollectionModel?> showCategory() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "userId": userId,
    // };
    final url = Uri.parse("${Api.baseUrl + Api.newCollection}?userId=$loginUserId");
    // final url = Uri.https(uri, Api.newCollection, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('New Collection Api STATUS CODE :: ${response.statusCode} Url :: $url  \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetNewCollectionModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
