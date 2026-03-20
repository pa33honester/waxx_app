import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/SelectedProductForLiveModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SelectedProductForLiveApi extends GetxService {
  Future<SelectedProductForLiveModel?> selectedProduct() async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "sellerId": sellerId,
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.selectedProductForLive}?sellerId=$sellerId");
    // final url = Uri.https(uri, Api.selectedProductForLive, params);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('Selected product for live :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SelectedProductForLiveModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Status code is not 200 Seller product select for live selling');
    }
  }
}
