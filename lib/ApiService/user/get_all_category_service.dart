import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

import '../../ApiModel/user/GetAllCategoryModel.dart';

class GetAllCategoryApi extends GetxService {
  Future<GetAllCategoryModel?> showCategory() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    final url = Uri.parse("${Api.baseUrl + Api.getAllCategory}");
    // final url = Uri.https(uri, Api.getAllCategory);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('Get All Category Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetAllCategoryModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
