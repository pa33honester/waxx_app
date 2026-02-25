import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/seller/SellerAllWalletAmountCountModel.dart';
import '../../utils/api_url.dart';
import '../../utils/globle_veriables.dart';

class SellerAllWalletAmountCountApi extends GetxService {
  Future<SellerAllWalletAmountCountModel?>
      sellerAllWalletAmountCountDetails() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "sellerId": sellerId,
    /*"startDate": startDate,
      "endDate": endDate,*/
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.walletCountForSeller}?sellerId=$sellerId");
    // final url = Uri.https("$uri", Api.walletCountForSeller, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('My Order Count Api URL :: $url STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SellerAllWalletAmountCountModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
