import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/seller/SellerOrderCountModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

class SellerOrderCountApi extends GetxService {
  Future<SellerMyOrderCountModel?> sellerMyOrderCountDetails({
    // required String sellerId,
    required String startDate,
    required String endDate,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "sellerId": sellerId,
    //   "startDate": startDate,
    //   "endDate": endDate,
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.orderCountForSeller}?sellerId=$sellerId&startDate=$startDate&endDate=$endDate");
    // final url = Uri.https(uri, Api.orderCountForSeller, params);

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
      return SellerMyOrderCountModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
