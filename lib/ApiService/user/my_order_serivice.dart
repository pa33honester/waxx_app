import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/MyOrdersModel.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

class MyOrderApi extends GetxService {
  Future<MyOrdersModel?> myOrderDetails({
    required String userId,
    required String status,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "userId": userId,
    //   "status": status,
    // };
    // final url = Uri.https(uri, Api.myOrders, params);
    final url = Uri.parse("${Api.baseUrl + Api.myOrders}?userId=$userId&status=$status");

    log("My order url :: $url");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    log('GET MY ORDER API Url :: $url \n  \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MyOrdersModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller product view');
    }
  }
}
