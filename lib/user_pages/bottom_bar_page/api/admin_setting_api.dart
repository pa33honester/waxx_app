import 'dart:convert';

import 'package:era_shop/user_pages/bottom_bar_page/model/admin_setting_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:http/http.dart' as http;

class AdminSettingsApi {
  static AdminSettingModel? adminSettingModel;
  static Future<void> callApi() async {
    Utils.showLog("Get Admin Settings Api Calling...");

    final uri = Uri.parse(Api.adminSetting);

    Utils.showLog("Get Admin Settings Api Url => $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Admin Settings Api Response => ${response.body}");

        adminSettingModel = AdminSettingModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Admin Settings Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Admin Settings Api Error => $error");
    }
  }
}
