import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/confirm_cod_order_seller_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class ConfirmCodOrderItemBySellerService {
  Future<ConfirmCodOrderSellerModel> confirmCodOrderItemBySeller({
    required String userId,
    required String orderId,
    required String itemId,
  }) async {
    final url = Uri.parse("${Api.baseUrl}${Api.confirmCodOrderItemBySeller}?userId=$userId&orderId=$orderId&itemId=$itemId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json',
    };

    final response = await http.patch(url, headers: headers);

    print('Confirm COD Order Item Response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ConfirmCodOrderSellerModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to confirm COD order item');
    }
  }
}
