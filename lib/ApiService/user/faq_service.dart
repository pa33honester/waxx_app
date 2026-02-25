import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/FAQModel.dart';
import '../../utils/api_url.dart';

class FAQApi extends GetxService {
  Future<FaqModel?> showFAQ() async {
    try {
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final url = Uri.parse("${Api.baseUrl + Api.faq}");
      // final url = Uri.https(uri, Api.faq);

      final response = await http.get(url, headers: headers);

      log('FAQ API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return FaqModel.fromJson(jsonResponse);
      } else {
        throw Exception('Status code is not 200');
      }
    } catch (e) {
      log("FAQ :: $e");
    }
    return null;
  }
}
