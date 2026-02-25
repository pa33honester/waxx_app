import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/GetAllPromoCodeModel.dart';

class GetAllPromoCodeApi extends GetxService {
  Future<GetAllPromoCodeModel?> showAllPromoCode() async {
    final url = Uri.parse(Api.baseUrl + Api.allPromoCode);
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('Get all promo code Api STATUS CODE :: ${response.statusCode} Url :: $url  \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return GetAllPromoCodeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
