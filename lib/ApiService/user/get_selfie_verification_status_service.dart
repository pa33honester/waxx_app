import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:waxxapp/ApiModel/user/SelfieVerificationModel.dart';
import 'package:waxxapp/utils/api_url.dart';

// GET /verification/myStatus?userId=
// Returns the user's latest verification submission (status + reason
// + autoCheckResult) so the Profile tile can render the right chip.
class GetSelfieVerificationStatusApi {
  static Future<SelfieVerificationModel?> fetch({required String userId}) async {
    try {
      final uri = Uri.parse(
        "${Api.baseUrl}${Api.getSelfieVerificationStatus}?userId=$userId",
      );
      final response = await http.get(
        uri,
        headers: {
          "key": Api.secretKey,
          "Content-Type": "application/json",
        },
      );
      log("getSelfieVerificationStatus status: ${response.statusCode}");
      if (response.statusCode == 200) {
        return SelfieVerificationModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      log("getSelfieVerificationStatus error: $e");
    }
    return null;
  }
}
