import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/user/CreateOrderByUserModel.dart';

class CreateOrderByUserApi {
  static Future<CreateOrderByUserModel> createOrderByUserApi({
    required String paymentGateway,
    required String promoCode,
    required num finalTotal,
    required int paymentStatus,
  }) async {
    final url = Uri.parse("${Api.baseUrl + Api.createOrderByUser}?userId=$loginUserId&paymentGateway=$paymentGateway&paymentStatus=$paymentStatus");

    print("PAYMENT URL :: ${url}");

    final body = jsonEncode({
      'promoCode': promoCode,
      'finalTotal': finalTotal,
    });

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('Create Order By User Status code :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CreateOrderByUserModel.fromJson(jsonResponse);
    } else {
      throw Exception('Create Order failed');
    }
  }

  static Future<bool> updateOrderItemStatusCallApi({
    required String userId,
    required String orderId,
    required String itemId,
    required String paymentGateway,
  }) async {
    Utils.showLog("Update Order Item Status Api Calling...");

    // Build URI with query parameters
    final uri = Uri.parse(Api.baseUrl + Api.sellerUpdateOrderItemStatus).replace(
      queryParameters: {
        'userId': userId,
        'orderId': orderId,
        'itemId': itemId,
        'paymentGateway': paymentGateway,
      },
    );

    Utils.showLog("Update Order Item Status API URL => $uri");

    final headers = {"key": Api.secretKey, "Content-Type": "application/json"};

    Utils.showLog("Update Order Item Status API Query Parameters => userId: $userId, orderId: $orderId, itemId: $itemId, paymentGateway: $paymentGateway");

    try {
      // Remove body parameter since data is now in query parameters
      final response = await http.patch(uri, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Update Order Item Status Successfully: ${response.body}");

        final jsonResponse = json.decode(response.body);
        if (jsonResponse["status"] == true) {
          return true;
        }
      } else {
        Utils.showLog("Update Order Item Status API Status Code Error => ${response.statusCode}");
        Utils.showLog("Error Response => ${response.body}");
      }
    } catch (error) {
      Utils.showLog("Update Order Item Status API Error => $error");
    }
    return false;
  }
}
