import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../ApiModel/seller/SellerTotalEarningModel.dart';
import '../../utils/api_url.dart';
import '../../utils/globle_veriables.dart';
import 'package:http/http.dart' as http;

class SellerTotalEarningService extends GetxService {
  Future<SellerTotalEarningModel?> selleTotalEarning() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "sellerId": sellerId,
    // };
    final url =
        Uri.parse("${Api.baseUrl + Api.sellerTotalEarning}?sellerId=$sellerId");
    // final url = Uri.https(uri, Api.sellerTotalEarning, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Seller Wallet Total Api URL :: $url STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SellerTotalEarningModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 ');
    }
  }
}
