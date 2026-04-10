import 'dart:convert';
import 'package:waxxapp/ApiModel/login/WhoLoginModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class WhoLoginApi {
  static Future<WhoLoginModel?> callApi({required String userId}) async {
    Utils.showLog("Who Login Api Calling...");

    final uri = Uri.parse("${Api.baseUrl + Api.userProfile}?userId=$userId");

    Utils.showLog("Who Login Api Url => $uri");

    final headers = {
      "key": Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Who Login Api Response => ${response.body}");

        return WhoLoginModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Who Login Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Who Login Api Error => $error");
    }
    return null;
  }
}