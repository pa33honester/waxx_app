import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/user/GetLiveSellerListModel.dart';

class LiveSellerListService extends GetxService {
  Future<SellerLiveStreamListModel?> getLiveSellerList({
    required String start,
    required String limit,
    required String userId,
  }) async {
    try {
      final url = Uri.parse("${Api.baseUrl + Api.liveSellerList}?start=$start&limit=$limit&userId=$userId");
      log('Get Live Seller List URL :: $url');
      // final url = Uri.https(uri, Api.liveSellerList, params);

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(url, headers: headers);

      log('Get Live Seller List STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SellerLiveStreamListModel.fromJson(jsonResponse);
      } else {
        throw Exception('Status code is not 200');
      }
    } finally {
      log("Get Live Seller List Finally");
    }
  }
}
