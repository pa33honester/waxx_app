import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:era_shop/ApiModel/seller/SellerProductDetailsModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';

class SellerProductDetailsApi extends GetxService {
  Future<SellerProductDetailsModel?> sellerProductDetails({
    required String productId,
    required String sellerId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "productId": productId,
    //   "sellerId": sellerId,
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.sellerProductDetails}?productId=$productId&sellerId=$sellerId");
    // final url = Uri.https(uri, Api.sellerProductDetails, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Seller Product Details Api :: $url STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SellerProductDetailsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
