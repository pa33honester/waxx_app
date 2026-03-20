import 'dart:convert';

import 'package:waxxapp/seller_pages/seller_wallet_page/model/fetch_withdraw_list_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchWithdrawMethodApi {
  static Future<FetchWithdrawListModel?> callApi() async {
    Utils.showLog("Get Withdraw Method Api Calling...");

    final uri = Uri.parse(Api.baseUrl + Api.withdrawalList);

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Withdraw Method Api Response => ${response.body}");

        return FetchWithdrawListModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Withdraw Method Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Withdraw Method Api Error => $error");
    }
    return null;
  }
}
