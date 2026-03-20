import 'dart:developer';

import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class ReelsLikeDislikeApi {
  static Future<void> callApi({required String loginUserId, required String videoId}) async {
    log("Reels Like-Dislike Api Calling...");

    final uri = Uri.parse("${Api.baseUrl + Api.shortsLikeAndDislike}?userId=$loginUserId&reelId=$videoId");

    final headers = {"key": Api.secretKey};
    log("Log:::::uri::::>>>$uri");

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        log("Reels Like-Dislike Api Response => ${response.body}");
      } else {
        log("Reels Like-Dislike Api StateCode Error");
      }
    } catch (error) {
      log("Reels Like-Dislike Api Error => $error");
    }
  }
}
