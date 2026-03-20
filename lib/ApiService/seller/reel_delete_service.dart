import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/seller/ReelDeleteModel.dart';

class ReelDeleteService extends GetxService {
  Future<ReelDeleteModel?> deleteReel({
    required String reelId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "reelId": reelId,
    // };

    final url =
        Uri.parse("${Api.baseUrl + Api.sellerReelDelete}?reelId=$reelId");
    // final url = Uri.https(uri, Api.sellerReelDelete, params);

    log("URL :: $url");

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final response = await http.delete(url, headers: headers);
    log('Delete Reel Api :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ReelDeleteModel.fromJson(jsonResponse);
    } else {
      log('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
    return null;
  }
}
