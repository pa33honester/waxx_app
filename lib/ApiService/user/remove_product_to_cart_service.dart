import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/ApiModel/user/RemoveProductToCartModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RemoveProductToCartApi extends GetxService {
  Future<RemoveProductToCartModel> removeProductToCart({
    required String userId,
    required String productId,
    required int productQuantity,
    required List<dynamic> attributes,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.removeTOCart);

    final body =
        jsonEncode({'userId': userId, 'productId': productId, 'productQuantity': productQuantity, 'attributesArray': attributes});

    log("userId :: $userId productId :: $productId productQuantity :: $productQuantity");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json',
    };
    final response = await http.patch(url, headers: headers, body: body);

    log('Remove Product To Cart API URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RemoveProductToCartModel.fromJson(jsonResponse);
    } else {
      throw Exception('Review is failed');
    }
  }
}
