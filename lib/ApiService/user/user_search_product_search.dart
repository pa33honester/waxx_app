import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../ApiModel/user/user_search_product_model.dart';
import '../../utils/api_url.dart';
import 'package:http/http.dart' as http;

class UserSearchProductApi extends GetxService {
  Future<UserSearchProductModel?> userSearchProductDetails({required String productName}) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   'productName': productName,
    //   "userId": userId,
    // };
    // final url = Uri.parse(Constant.BASE_URL + Constant.searchProduct);
    final url = Uri.parse("${Api.baseUrl + Api.searchProduct}?productName=$productName&userId=$loginUserId");
    // final url = Uri.https(uri, Api.searchProduct, params);

    log("URL :: $url");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      url,
      headers: headers,
    );

    log('USER SEARCH PRODUCT API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserSearchProductModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
