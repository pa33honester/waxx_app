import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/ApiModel/seller/DeleteCatalogBySellerModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteCatalogApi extends GetxService {
  Future<DeleteCatalogBySellerModel?> deleteCatalog({
    required String productId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "productId": productId,
    // };

    // final url = Uri.https(uri, Api.sellerProductDelete, params);
    final url = Uri.parse(
        "${Api.baseUrl + Api.sellerProductDelete}?productId=$productId");

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final response = await http.delete(url, headers: headers);
    log('Delete Catalog Api :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      // Handle success response
      final jsonResponse = json.decode(response.body);
      return DeleteCatalogBySellerModel.fromJson(jsonResponse);
    } else {
      // Handle error response
      log('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
    return null;
  }
}
