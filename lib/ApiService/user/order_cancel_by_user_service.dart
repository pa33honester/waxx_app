import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/OrderCancelByUserModel.dart';

class OrderCancelByUserService extends GetxService {
  Future<OrderCancelByUserModel> orderCancelByUser({
    required String orderId,
    // required String status,
    required String itemId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "userId": userId,
    //   "orderId": orderId,
    //   "status": "Cancelled",
    //   "itemId": itemId,
    // };
    // log("Paramsss :: $params");
    // final url = Uri.https(uri, Api.orderCancelByUser, params);
    final url = Uri.parse("${Api.baseUrl + Api.orderCancelByUser}?userId=$loginUserId&orderId=$orderId&status=Cancelled&itemId=$itemId");

    log("Url :: $url");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.patch(url, headers: headers);

    log('Order Cancel By User STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return OrderCancelByUserModel.fromJson(jsonResponse);
    } else {
      throw Exception('Order Cancel By User call failed');
    }
  }
}
