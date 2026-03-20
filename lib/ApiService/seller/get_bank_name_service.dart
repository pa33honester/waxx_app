import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/get_all_bank_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetBankService extends GetxService {
  Future<GetAllBankModel?> getBank() async {
    log("Get All Bank Model Api Calling... ");

    final uri = Uri.parse(Api.baseUrl + Api.getAllBank);

    log("*** $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Get All Bank Model Response => ${response.body}");

        return GetAllBankModel.fromJson(jsonResponse);
      } else {
        log("Get All Bank Model Error");
      }
    } catch (error) {
      log("Get All Bank Model Api Error => $error");
    }
    return null;
  }
}
