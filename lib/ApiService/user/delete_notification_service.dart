import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/database.dart';

/// Delete-one + delete-all surface for the user's notifications list.
/// Both endpoints gate the destructive action on `userId` ownership in
/// the backend — the secret key + `userId` query param together act as
/// the auth boundary.
class DeleteNotificationService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Removes a single notification by id. The Flutter list optimistically
  /// drops the row before this call lands; the boolean here is what the
  /// caller uses to decide whether to put the row back on failure.
  static Future<bool> deleteOne(String notificationId) async {
    if (notificationId.isEmpty) return false;
    final uri = Uri.parse(
      "${Api.baseUrl}${Api.deleteNotification}/$notificationId?userId=${Database.loginUserId}",
    );
    log("DeleteNotification → $uri");
    try {
      final res = await http.delete(uri, headers: _headers);
      log("DeleteNotification ← ${res.statusCode} ${res.body}");
      if (res.statusCode != 200) return false;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body["status"] == true;
    } catch (e) {
      log("DeleteNotification error: $e");
      return false;
    }
  }

  /// Wipes every notification belonging to the logged-in user.
  static Future<bool> clearAll() async {
    final uri = Uri.parse(
      "${Api.baseUrl}${Api.clearAllNotifications}?userId=${Database.loginUserId}",
    );
    log("ClearAllNotifications → $uri");
    try {
      final res = await http.delete(uri, headers: _headers);
      log("ClearAllNotifications ← ${res.statusCode} ${res.body}");
      if (res.statusCode != 200) return false;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body["status"] == true;
    } catch (e) {
      log("ClearAllNotifications error: $e");
      return false;
    }
  }
}
