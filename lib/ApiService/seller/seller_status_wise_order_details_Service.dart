// ignore_for_file: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../ApiModel/seller/SellerStatusWiseOrderDetailsModel.dart';

class SellerStatusWiseOrderDetailsApi extends GetxService {
  Future<SellerStatusWiseOrderDetailsModel?> sellerStatusWiseOrderDetails({
    required String startDate,
    required String endDate,
    required String status,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "sellerId": sellerId,
    //   "status": status,
    //   "startDate": startDate,
    //   "endDate": endDate,
    // };
    final url = Uri.parse("${Api.baseUrl + Api.orderDetailsForSeller}?sellerId=$sellerId&status=$status&startDate=$startDate&endDate=$endDate");
    // final url = Uri.https("$uri", Api.orderDetailsForSeller, params);
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Seller Order Details Api URL :: $url \nSTATUS CODE :: ${response.statusCode} \nRESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SellerStatusWiseOrderDetailsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
