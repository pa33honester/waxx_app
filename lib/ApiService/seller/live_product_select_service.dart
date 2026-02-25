import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/ApiModel/seller/LiveProductSelect.dart';
import 'package:http/http.dart' as http;
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';

class LiveProductSelectApi extends GetxService {
  Future<LiveProductSelect?> liveProductSelect({
    required String productId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    try {
      // final params = {
      //   "productId": productId,
      // };

      final url = Uri.parse(
          "${Api.baseUrl + Api.productSelectOrNot}?productId=$productId");
      // final url = Uri.https(uri, Api.productSelectOrNot, params);

      var request = http.MultipartRequest("PATCH", url);

      request.headers.addAll({
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var res1 = await request.send();
      var response = await http.Response.fromStream(res1);
      log('Live Product Select Api :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return LiveProductSelect.fromJson(data);
      } else {
        log("STATUS CODE:-${response.statusCode.toString()}");
        log(response.reasonPhrase.toString());
      }
    } finally {
      log("%%%%%%%%%%%%%%%%%% Response Complete");
    }
    return null;
  }
}
