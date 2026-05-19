import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/user_pages/product_chat/model/product_chat_model.dart';
import 'package:waxxapp/utils/api_url.dart';

class ProductChatFilterException implements Exception {
  final String message;
  ProductChatFilterException(this.message);
  @override
  String toString() => message;
}

class ProductChatService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<ProductChatConversation?> getOrCreateConversation({
    required String buyerId,
    required String sellerId,
    required String productId,
  }) async {
    if (buyerId.isEmpty || sellerId.isEmpty || productId.isEmpty) return null;
    final uri = Uri.parse(
        "${Api.baseUrl}${Api.productChatConversation}?buyerId=$buyerId&sellerId=$sellerId&productId=$productId");
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) return null;
      return ProductChatConversation.fromJson(body["conversation"] as Map<String, dynamic>);
    } catch (e) {
      log("ProductChatService.getOrCreateConversation error: $e");
      return null;
    }
  }

  static Future<ProductChatMessage?> sendBuyerMessage({
    required String conversationId,
    required String buyerId,
    required String text,
  }) async {
    final uri = Uri.parse("${Api.baseUrl}${Api.productChatSendBuyer}");
    try {
      final res = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({"conversationId": conversationId, "buyerId": buyerId, "text": text.trim()}),
      );
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) {
        final msg = (body["message"] as String? ?? "");
        if (msg.toLowerCase().contains("cannot contain")) {
          throw ProductChatFilterException(msg);
        }
        return null;
      }
      final data = body["data"];
      if (data is Map) return ProductChatMessage.fromJson(Map<String, dynamic>.from(data));
      return null;
    } on ProductChatFilterException {
      rethrow;
    } catch (e) {
      log("ProductChatService.sendBuyerMessage error: $e");
      return null;
    }
  }

  static Future<ProductChatMessage?> sendSellerMessage({
    required String conversationId,
    required String sellerId,
    required String text,
  }) async {
    final uri = Uri.parse("${Api.baseUrl}${Api.productChatSendSeller}");
    try {
      final res = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({"conversationId": conversationId, "sellerId": sellerId, "text": text.trim()}),
      );
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) {
        final msg = (body["message"] as String? ?? "");
        if (msg.toLowerCase().contains("cannot contain")) {
          throw ProductChatFilterException(msg);
        }
        return null;
      }
      final data = body["data"];
      if (data is Map) return ProductChatMessage.fromJson(Map<String, dynamic>.from(data));
      return null;
    } on ProductChatFilterException {
      rethrow;
    } catch (e) {
      log("ProductChatService.sendSellerMessage error: $e");
      return null;
    }
  }
}
