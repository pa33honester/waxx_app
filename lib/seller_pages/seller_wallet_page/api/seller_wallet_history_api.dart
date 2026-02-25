import 'dart:convert';

import 'package:era_shop/seller_pages/seller_wallet_page/model/fetch_seller_history_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchSellerWalletHistoryApi {
  static Future<FetchSellerWalletHistoryModel?> callApi({
    required String sellerId,
    required String startDate,
    required String endDate,
  }) async {
    Utils.showLog("Get Wallet History Api Calling...");

    final uri = Uri.parse("${Api.baseUrl + Api.getSellerWalletHistory}?startDate=$startDate&endDate=$endDate&sellerId=$sellerId");

    final headers = {"key": Api.secretKey};

    Utils.showLog("Get Wallet History Api Url => $uri");

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Wallet History Api Response => ${response.body}");

        return FetchSellerWalletHistoryModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Wallet History Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Wallet History Api Error => $error");
    }
    return null;
  }
}
