import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/seller/ShowUploadedReelsModel.dart';

class ShowUploadedReelsApi extends GetxService {
  Future<ShowUploadedReelsModel> showUploadedReels({
    required String start,
    required String limit,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "start": start,
    //   "limit": limit,
    //   "sellerId": sellerId,
    // };
    final url = Uri.parse(
        "${Api.baseUrl + Api.sellerUploadedShort}?start=$start&limit=$limit&sellerId=$sellerId");
    // final url = Uri.https(uri, Api.sellerUploadedShort, params);

    log('URL :: $url');

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('Show Uploaded shorts Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ShowUploadedReelsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
