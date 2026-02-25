import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/user_pages/popular_products_page/model/popular_product_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:http/http.dart' as http;

class PopularProductApi {
  static Future<PopularProductModel?> callApi() async {
    log("Get Products product Api Calling... ");

    final uri = Uri.parse(Api.baseUrl + Api.featuredProducts);

    final headers = {"key": Api.secretKey};

    log("**************** $uri ******* $headers");

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Get Popular product Api Response => ${response.body}");
        return PopularProductModel.fromJson(jsonResponse);
      } else {
        log("Get Popular product Api StateCode Error");
      }
    } catch (error) {
      log("Get Popular product Api Error => $error");
    }
    return null;
  }
}
