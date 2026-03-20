import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/AddProductToCartModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddProductToCartApi extends GetxService {
  Future<AddProductToCartModel> addProductToCart({
    required String userId,
    required String productId,
    required int productQuantity,
    required List<dynamic> attributes,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.addTOCart);

    final body = jsonEncode({
      'userId': userId,
      'productId': productId,
      'productQuantity': productQuantity,
      'attributesArray': attributes,
    });

    log("Service :::: userId :: $userId \n productId :: $productId \n productQuantity :: $productQuantity \n attributesArray :: $attributes");
    log("PAYLOAD :: $body");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('AddProductToCart API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AddProductToCartModel.fromJson(jsonResponse);
    } else {
      throw Exception('Review is failed');
    }
  }
}
