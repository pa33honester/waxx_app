import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../ApiModel/seller/PendingOrderAmountModel.dart';
import '../../utils/api_url.dart';
import '../../utils/globle_veriables.dart';
import 'package:http/http.dart' as http;

class SellerWalletPendingAmountApi extends GetxService {
  Future<PendingOrderAmountModel?> sellerWalletPendingAmountDetails() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "sellerId": sellerId,
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.pendingWalletAmountForSeller}?sellerId=$sellerId");
    // final url = Uri.https(uri, Api.pendingWalletAmountForSeller, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Seller Wallet Pending Details Api URL :: $url STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PendingOrderAmountModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 ');
    }
  }
}
