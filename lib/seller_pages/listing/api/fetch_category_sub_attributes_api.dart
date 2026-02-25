import 'dart:convert';
import 'package:era_shop/seller_pages/listing/model/fetch_category_sub_attr_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchCategorySubAttributesApi {
  static Future<FetchCategorySubAttrModel?> callApi() async {
    Utils.showLog("Fetching Category, Subcategory & Attributes API Calling...");

    final uri = Uri.parse(Api.baseUrl + Api.fetchCategorySubAttr);

    Utils.showLog("Category API URL => $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Category API Response => ${response.body}");

        return FetchCategorySubAttrModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Category API Status Code Error => ${response.statusCode}");
      }
    } catch (error) {
      Utils.showLog("Category API Error => $error");
    }
    return null;
  }
}
