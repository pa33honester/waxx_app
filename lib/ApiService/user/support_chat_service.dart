import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/user/support_conversation_model.dart';
import 'package:waxxapp/utils/api_url.dart';

/// HTTP transport for the live customer-support chat. The realtime
/// stream of new messages comes over Socket.io (see
/// `socket_services.dart`'s `supportMessage` listener); this service is
/// for the request/reply parts: fetching the conversation snapshot on
/// entry and posting user-typed messages.
class SupportChatService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Fetches (or lazily creates) the user's support conversation. Idempotent
  /// — calling it on a fresh user spins up a new SupportConversation row;
  /// calling it on a returning user replays their full message history. Side
  /// effect: marks all admin-sent messages as read on the backend, which
  /// resets the unread badge.
  static Future<SupportConversation?> fetchMyConversation({
    required String userId,
  }) async {
    if (userId.isEmpty) return null;
    final uri = Uri.parse("${Api.baseUrl}${Api.supportMyConversation}?userId=$userId");
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) return null;
      return SupportConversation.fromJson(body["conversation"] as Map<String, dynamic>);
    } catch (e) {
      log("SupportChatService.fetchMyConversation error: $e");
      return null;
    }
  }

  /// Sends a user-side message. On 200 the backend has already broadcast
  /// the message via Socket.io to the `supportRoom:<conversationId>`
  /// room AND signaled the admin inbox, so the controller's optimistic
  /// append is reconciled when the socket echo arrives.
  static Future<SupportMessage?> sendMessage({
    required String userId,
    required String text,
  }) async {
    if (userId.isEmpty || text.trim().isEmpty) return null;
    final uri = Uri.parse("${Api.baseUrl}${Api.supportSendUserMessage}");
    try {
      final res = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({"userId": userId, "text": text.trim()}),
      );
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) return null;
      final data = body["data"];
      if (data is Map) {
        return SupportMessage.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      log("SupportChatService.sendMessage error: $e");
      return null;
    }
  }
}
