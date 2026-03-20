import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/GetReelsForUserModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class FetchReelsApi {
  static int startPagination = 1;
  static int limitPagination = 20;

  static Future<GetReelsForUserModel?> callApi({required String loginUserId, required String reelId}) async {
    log("Get Reels Api Calling... ");

    startPagination += 1;

    log("Get Reels Pagination Page => $startPagination");

    final uri = Uri.parse("${Api.baseUrl + Api.getShortForUser}?start=$startPagination&limit=$limitPagination&userId=$loginUserId&reelId=$reelId");

    final headers = {"key": Api.secretKey};

    log("Get Reels Api URL => ${uri}");

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Get Reels Api Response => ${response.body}");
        return GetReelsForUserModel.fromJson(jsonResponse);
      } else {
        log("Get Reels Api StateCode Error");
      }
    } catch (error) {
      log("Get Reels Api Error => $error");
    }
    return null;
  }
}
