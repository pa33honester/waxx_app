import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:waxxapp/ApiModel/user/SelfieVerificationModel.dart';
import 'package:waxxapp/utils/api_url.dart';

// Multipart POST /verification/submitSelfie
// Field name "selfie" (must match the backend route's
// upload.single("selfie")). The KYC-aware multer storage routes the
// file to private_storage/ based on this fieldname.
class SubmitSelfieVerificationApi {
  // Map a file extension to its image MediaType. Without an explicit
  // contentType, `http.MultipartFile.fromPath` sends
  // `application/octet-stream`, which the backend's KYC multer
  // fileFilter rejects — that's why "Couldn't submit. Please try
  // again." showed up on every selfie upload. ImagePicker with
  // imageQuality set always re-encodes to JPEG, so the default is
  // image/jpeg; the switch keeps us correct if that ever changes.
  static MediaType _getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'jpg':
      case 'jpeg':
      default:
        return MediaType('image', 'jpeg');
    }
  }

  static Future<SelfieVerificationModel?> submit({
    required String userId,
    required File selfieFile,
    Map<String, dynamic>? autoCheckResult,
  }) async {
    try {
      final uri = Uri.parse(Api.baseUrl + Api.submitSelfieVerification);
      final request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'selfie',
          selfieFile.path,
          contentType: _getMediaType(selfieFile.path),
        ),
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
