import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/ApiModel/user/FavoriteItemsModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoriteItemApi extends GetxService {
  Future<FavoriteItemsModel?> showFavoriteItem() async {
    try {
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      final params = {
        "userId": loginUserId,
        // "categoryId": categoryId,
      };

      final url = Uri.parse("${Api.baseUrl + Api.favoriteProducts}?userId=$loginUserId");
      // final url = Uri.https(uri, Api.favoriteProducts, params);

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(url, headers: headers);

      log('Get Favorite Data Status Code :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return FavoriteItemsModel.fromJson(jsonResponse);
      } else {
        throw Exception('Status code is not 200');
      }
    } finally {
      log("message");
    }
  }
}
