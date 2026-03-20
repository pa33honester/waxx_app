import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/ShowCatalogModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

class ShowCatalogApi extends GetxService {
  Future<ShowCatalogModel> showCatalogs({
    required String start,
    required String limit,
    required String search,
    required String saleType,
  }) async {
    final url = Uri.parse("${Api.baseUrl + Api.allProductForSeller}?start=$start&limit=$limit&sellerId=$sellerId&search=$search&saleType=$saleType");

    log('URL :: $url');

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Show Catalog Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ShowCatalogModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
