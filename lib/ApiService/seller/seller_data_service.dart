import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

import '../../ApiModel/seller/seller_data_model.dart';
import '../../utils/globle_veriables.dart';

class SellerDataApi extends GetxService {
  Future<SellerDataModel?> sellerData() async {
    final url = Uri.parse(Api.baseUrl + Api.sellerAllData);
    log("Final seller Url :: $url");

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    log("User id is :: $loginUserId");
    log("isDemoSeller :: $isDemoSeller");

    final body = jsonEncode({
      'userId': loginUserId,
    });
    final response = await http.post(url, headers: headers, body: body);
    log('Get all seller data :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SellerDataModel.fromJson(jsonResponse);
    } else {
      throw Exception('Seller Login Failed');
    }
  }
}
