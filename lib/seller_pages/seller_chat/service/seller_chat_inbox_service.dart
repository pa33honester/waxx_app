import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/seller_pages/seller_chat/model/seller_chat_inbox_model.dart';
import 'package:waxxapp/utils/api_url.dart';

class SellerChatInboxService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<List<SellerChatInboxTile>> fetchInbox({
    required String sellerId,
    int page = 1,
    int limit = 20,
  }) async {
    if (sellerId.isEmpty) return [];
    final uri = Uri.parse(
        "${Api.baseUrl}${Api.productChatSellerInbox}?sellerId=$sellerId&page=$page&limit=$limit");
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) return [];
      final list = body["conversations"] as List? ?? [];
      return list.map((x) => SellerChatInboxTile.fromJson(x)).toList();
    } catch (e) {
      log("SellerChatInboxService.fetchInbox error: $e");
      return [];
    }
  }
}
