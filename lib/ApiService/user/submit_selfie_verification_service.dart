import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:waxxapp/ApiModel/user/SelfieVerificationModel.dart';
import 'package:waxxapp/utils/api_url.dart';

// Multipart POST /verification/submitSelfie
// Field name "selfie" (must match the backend route's
// upload.single("selfie")). The KYC-aware multer storage routes the
// file to private_storage/ based on this fieldname.
class SubmitSelfieVerificationApi {
  static Future<SelfieVerificationModel?> submit({
    required String userId,
    required File selfieFile,
    Map<String, dynamic>? autoCheckResult,
  }) async {
    try {
      final uri = Uri.parse(Api.baseUrl + Api.submitSelfieVerification);
      final request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath('selfie', selfieFile.path),
      );

      request.headers.addAll({
        "key": Api.secretKey,
      });

      final fields = <String, String>{"userId": userId};
      if (autoCheckResult != null) {
        // Multipart form fields can only be strings; backend parses
        // JSON for us. Keep this in sync with the schema in
        // verification.model.js (faceCount, leftEyeOpen, etc.).
        fields["autoCheckResult"] = jsonEncode(autoCheckResult);
      }
      request.fields.addAll(fields);

      final stream = await request.send();
      final response = await http.Response.fromStream(stream);
      log("submitSelfie status: ${response.statusCode}, body: ${response.body}");
      if (response.statusCode == 200) {
        return SelfieVerificationModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      log("submitSelfie error: $e");
    }
    return null;
  }
}
