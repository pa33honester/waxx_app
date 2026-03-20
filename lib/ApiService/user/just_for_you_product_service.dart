import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

import '../../ApiModel/user/JustForYouProductModel.dart';

class JustForYouApi extends GetxService {
  Future<JustForYouProductModel?> showProduct() async {
    // final url = Uri.parse(Constant.BASE_URL + Constant.justForYouProduct);
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "userId": userId,
    // };
    // final url = Uri.https(uri, Api.justForYouProduct, params);
    final url = Uri.parse("${Api.baseUrl + Api.justForYouProduct}?userId=$loginUserId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    log('Just for you Api  url :: $url');
    log('Just for you Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return JustForYouProductModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200');
    }
  }
}
