import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/ApiModel/login/IpApiModel.dart';
import 'package:era_shop/ApiModel/login/check_password_model.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class IpApiService extends GetxService {
  static const String baseUrl = "http://ip-api.com/json";

  static Future<IpApiModel?> fetchIpDetails() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return ipApiModelFromJson(response.body);
      } else {
        print("Failed to load IP data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching IP data: $e");
      return null;
    }
  }
}
