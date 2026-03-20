import 'dart:convert';
import 'package:waxxapp/seller_pages/seller_wallet_page/model/create_withdraw_request_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class SellerCreateWithdrawRequestApi {
  static Future<CreateWithdrawRequestModel?> callApi({
    required String sellerId,
    required String amount,
    required String paymentGateway,
    required List<String> paymentDetails,
  }) async {
    Utils.showLog("Seller With Draw Request Api Calling...");

    final uri = Uri.parse(Api.baseUrl + Api.createWithdraw);
    Utils.showLog("Withdraw Request uri => ${uri}");

    final headers = {"key": Api.secretKey, "Content-Type": "application/json; charset=UTF-8"};

    final body = json.encode({
      "sellerId": sellerId,
      "paymentGateway": paymentGateway,
      "paymentDetails": paymentDetails,
      "amount": amount,
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      Utils.showLog("Withdraw Request Body => ${body}");
      Utils.showLog("Withdraw Request statusCode => ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Seller With Draw Request Api Response => ${response.body}");
        return CreateWithdrawRequestModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Seller With Draw Request Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Seller With Draw Request Api Error => $error");
    }
    return null;
  }
}
