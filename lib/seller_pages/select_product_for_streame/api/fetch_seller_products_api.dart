import 'dart:convert';
import 'package:era_shop/seller_pages/select_product_for_streame/model/fetch_product_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchProductInventoryApi {
  static int startPagination = 1; // Start from page 1
  static const int limitPagination = 20; // Items per page
  /// Sale Type >>>>> 1. Buy Now, 2. Auction

  static Future<FetchProductInventoryModel?> callApi({
    required String sellerId,
    String? search,
    int? saleType,
  }) async {
    Utils.showLog("Fetching Product Inventory - Page: $startPagination");
    final uri = Uri.parse("${Api.baseUrl}${Api.allProductForSeller}?start=$startPagination&limit=$limitPagination&sellerId=$sellerId&search=$search&saleType=$saleType");
    Utils.showLog("Product Inventory API URL => $uri");
    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Product Inventory API Response => ${response.body}");

        startPagination++; // Increment page for next call

        return FetchProductInventoryModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Product Inventory API Status Code Error => ${response.statusCode}");
      }
    } catch (error) {
      Utils.showLog("Product Inventory API Error => $error");
    }
    return null;
  }
}
