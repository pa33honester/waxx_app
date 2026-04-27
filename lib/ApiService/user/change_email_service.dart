import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Two-step email change for the logged-in user.
///
///   1. [requestCode] sends a 6-digit code to the new email.
///   2. [verifyCode] commits the change once the user enters the code.
///
/// Result tuple is `(success, message, devCode)`. `devCode` is non-null when
/// the backend has no Resend key configured (dev/staging) — UI surfaces it as
/// a debug aid so the flow can still be completed without real email infra.
class ChangeEmailService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<({bool ok, String message, String? devCode})> requestCode({
    required String userId,
    required String newEmail,
  }) async {
    final uri = Uri.parse(Api.baseUrl + Api.changeEmailRequest);
    final body = jsonEncode({"userId": userId, "newEmail": newEmail});
    log("ChangeEmail request → $uri body=$body");
    try {
      final res = await http.post(uri, headers: _headers, body: body);
      log("ChangeEmail request ← ${res.statusCode} ${res.body}");
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (
        ok: json["status"] == true,
        message: (json["message"] ?? "").toString(),
        devCode: json["devCode"]?.toString(),
      );
    } catch (e) {
      log("ChangeEmail request error: $e");
      return (ok: false, message: "Network error. Please try again.", devCode: null);
    }
  }

  static Future<({bool ok, String message, String? newEmail})> verifyCode({
    required String userId,
    required String code,
  }) async {
    final uri = Uri.parse(Api.baseUrl + Api.changeEmailVerify);
    final body = jsonEncode({"userId": userId, "code": code});
    log("ChangeEmail verify → $uri body=$body");
    try {
      final res = await http.post(uri, headers: _headers, body: body);
      log("ChangeEmail verify ← ${res.statusCode} ${res.body}");
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (
        ok: json["status"] == true,
        message: (json["message"] ?? "").toString(),
        newEmail: json["email"]?.toString(),
      );
    } catch (e) {
      log("ChangeEmail verify error: $e");
      return (ok: false, message: "Network error. Please try again.", newEmail: null);
    }
  }
}
