import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/RemoveAllProductFromCartModel.dart';
import '../../utils/api_url.dart';

class RemoveAllProductFromCartService extends GetxService {
  Future<RemoveAllProductFromCartModel?> removeAllProduct() async {
    // final params = {"userId": userId};
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final url = Uri.https(uri, Api.deleteAllCartProduct, params);
    final url = Uri.parse("${Api.baseUrl + Api.deleteAllCartProduct}?userId=$loginUserId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.delete(url, headers: headers);
    log('Remove all product from cart STATUS CODE :: ${response.statusCode} Url :: $url  \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return RemoveAllProductFromCartModel.fromJson(jsonResponse);
    } else {
      throw Exception('Remove all product from cart');
    }
  }
}
