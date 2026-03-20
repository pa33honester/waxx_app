import 'dart:convert';

import 'package:waxxapp/seller_pages/seller_wallet_page/model/fetch_withdraw_history_model.dart';
import 'package:waxxapp/seller_pages/seller_wallet_page/model/fetch_withdraw_list_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchSellerWithdrawHistoryApi {
  static Future<FetchSellerWithdrawHistory?> callApi({
    required String sellerId,
    required String startDate,
    required String endDate,
  }) async {
    Utils.showLog("Get Withdraw History Api Calling...");

    final uri = Uri.parse("${Api.baseUrl + Api.getWithdrawalRequestsBySeller}?startDate=$startDate&endDate=$endDate&sellerId=$sellerId");

    final headers = {"key": Api.secretKey};

    Utils.showLog("Get Withdraw History Api Url => $uri");

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Withdraw History Api Response => ${response.body}");

        return FetchSellerWithdrawHistory.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Withdraw History Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Withdraw History Api Error => $error");
    }
    return null;
  }
}
