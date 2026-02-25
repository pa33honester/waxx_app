import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/login/SettingApiModel.dart';

class SettingApi extends GetxService {
  Future<SettingApiModel?> settingApi() async {
    final url = Uri.parse(Api.adminSetting);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('Setting Api :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SettingApiModel.fromJson(jsonResponse);
    } else {
      throw Exception('Setting Api Status code is not 200');
    }
  }
}
