import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Replay the chat-comment backlog for a live show. Buyers who join
/// mid-stream call this once before the socket starts streaming new
/// comments — the result is appended to `mainLiveComments` (same shape
/// the socket emits: `{ userName, userImage, commentText, type, ... }`)
/// so the existing renderer in `live_widget.dart` handles it with no
/// special casing.
///
/// Returns an empty list on any error — chat history is best-effort, a
/// failure here mustn't block the user from joining the live.
class FetchLiveChatHistoryService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<List<Map<String, dynamic>>> fetch({
    required String liveSellingHistoryId,
    int limit = 50,
  }) async {
    if (liveSellingHistoryId.isEmpty) return const [];
    final uri = Uri.parse(
      "${Api.baseUrl}${Api.liveChatHistory}/$liveSellingHistoryId?limit=$limit",
    );
    log("FetchLiveChatHistory → $uri");
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) {
        log("FetchLiveChatHistory ← ${res.statusCode}");
        return const [];
      }
      final json = jsonDecode(res.body);
      if (json is Map && json["status"] == true && json["comments"] is List) {
        final list = json["comments"] as List;
        return list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return const [];
    } catch (e) {
      log("FetchLiveChatHistory error: $e");
      return const [];
    }
  }
}
