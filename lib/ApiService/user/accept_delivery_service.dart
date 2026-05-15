import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

class AcceptDeliveryService extends GetxService {
  Future<({bool status, String message})> acceptDelivery({
    required String orderId,
    required String itemId,
  }) async {
    final url = Uri.parse(
      "${Api.baseUrl + Api.acceptDeliveryByBuyer}?userId=$loginUserId&orderId=$orderId&itemId=$itemId",
    );
    log("Accept Delivery URL :: $url");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.patch(url, headers: headers);
    log('Accept Delivery STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return (
        status: (body['status'] as bool?) ?? false,
        message: (body['message'] as String?) ?? '',
      );
    }
    throw Exception('Accept Delivery call failed (status ${response.statusCode})');
  }
}
