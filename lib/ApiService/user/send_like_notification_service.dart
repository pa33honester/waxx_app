import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

class SendLikeNotificationApi {
  /// Fires a request to the backend to push a "liked your product" notification
  /// to the product's seller. Fire-and-forget — errors are swallowed so they
  /// never break the like flow for the user.
  static Future<void> notify({required String productId}) async {
    try {
      final url = Uri.parse(Api.baseUrl + Api.sendProductLikedNotification);
      final body = jsonEncode({
        'productId': productId,
        'userId': loginUserId,
        'userName': '$editFirstName $editLastName'.trim(),
      });
      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await http.post(url, headers: headers, body: body);
      log('SendLikeNotification :: ${response.statusCode}');
    } catch (e) {
      log('SendLikeNotification error (non-fatal): $e');
    }
  }
}
