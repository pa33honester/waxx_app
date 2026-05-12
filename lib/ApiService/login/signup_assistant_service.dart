import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/login/account_request_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// HTTP for the in-app sign-up assistant chatbot. The only call is
/// submitting the prospective user's collected details as a pending
/// account request — an admin then reviews + approves it in the admin
/// panel, which creates the real account. Mirrors the lightweight
/// static-method pattern used by [SupportChatService].
class SignupAssistantService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<AccountRequestModel?> submitAccountRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? mobileNumber,
    String? countryCode,
  }) async {
    try {
      final uri = Uri.parse("${Api.baseUrl}${Api.submitAccountRequest}");
      final res = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          "firstName": firstName.trim(),
          "lastName": lastName.trim(),
          "email": email.trim(),
          "password": password,
          if (mobileNumber != null && mobileNumber.trim().isNotEmpty) "mobileNumber": mobileNumber.trim(),
          if (countryCode != null && countryCode.trim().isNotEmpty) "countryCode": countryCode.trim(),
          "identity": identify,
          "source": "signup_assistant",
        }),
      );
      final body = jsonDecode(res.body);
      if (body is Map<String, dynamic>) {
        return AccountRequestModel.fromJson(body);
      }
      return null;
    } catch (e) {
      log("SignupAssistantService.submitAccountRequest error: $e");
      return null;
    }
  }
}
