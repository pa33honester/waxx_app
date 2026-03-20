import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/UserProductDetailsModel.dart';
import 'package:waxxapp/ApiModel/user/related_product_model.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

class UserProductDetailsApi extends GetxService {
  Future<UserProductDetailsModel?> userProductDetails({
    required String productId,
    required String userId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "productId": productId,
    //   "userId": userId,
    // };
    final url = Uri.parse("${Api.baseUrl + Api.userProductDetails}?productId=$productId&userId=$userId");
    // final url = Uri.https(uri, Api.userProductDetails, params);

    log("URL :: $url");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('USER DETAILS API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserProductDetailsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }

  Future<RelatedProductModel?> relatedProducts({
    required String productId,
    required String userId,
    required String categoryId,
  }) async {
    final url = Uri.parse("${Api.baseUrl + Api.getRelatedProductsByCategory}?productId=$productId&userId=$userId&categoryId=$categoryId");

    log("Related Product api URL :: $url");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('Related Product API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RelatedProductModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
