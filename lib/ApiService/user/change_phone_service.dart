import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Commits a phone-number change after the Flutter client has already
/// completed Firebase OTP verification of the new number. The backend
/// trusts the client (matches the existing signup contract) but enforces
/// uniqueness so two accounts can't share a number.
class ChangePhoneService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<({bool ok, String message})> commit({
    required String userId,
    required String newMobileNumber,
    required String newCountryCode,
  }) async {
    final uri = Uri.parse(Api.baseUrl + Api.changePhone);
    final body = jsonEncode({
      "userId": userId,
      "newMobileNumber": newMobileNumber,
      "newCountryCode": newCountryCode,
    });
    log("ChangePhone → $uri body=$body");
    try {
      final res = await http.post(uri, headers: _headers, body: body);
      log("ChangePhone ← ${res.statusCode} ${res.body}");
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (
        ok: json["status"] == true,
        message: (json["message"] ?? "").toString(),
      );
    } catch (e) {
      log("ChangePhone error: $e");
      return (ok: false, message: "Network error. Please try again.");
    }
  }
}
