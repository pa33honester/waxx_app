import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/ApiModel/user/GetReviewModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetReviewApi extends GetxService {
  Future<GetReviewModel?> getReviewDetails({
    required String productId,
  }) async {
    // var params = {
    //   "productId": productId,
    // };
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final url = Uri.https(uri, Api.getReviewDetails, params);
    final url =
        Uri.parse("${Api.baseUrl + Api.getReviewDetails}?productId=$productId");

    log("URL :: $url");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('GET REVIEW API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetReviewModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
