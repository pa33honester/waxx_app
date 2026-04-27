import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:waxxapp/ApiModel/seller/scheduled_live_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class ScheduleLiveService {
  // For multipart we don't set Content-Type — http will set the boundary.
  // Legacy GET still uses the JSON header.
  final _jsonHeaders = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  /// Schedule a new show. Always sent as multipart/form-data so the
  /// backend's multer middleware sees the optional [coverImage] file
  /// when one is supplied. When [coverImage] is null only the form
  /// fields are sent and the backend stores `image: ""`.
  Future<ScheduledLiveModel> scheduleLive({
    required String sellerId,
    required String title,
    required String description,
    required DateTime scheduledAt,
    File? coverImage,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.scheduleLive);
    log('ScheduleLive URL :: $url  coverImage=${coverImage?.path}');
    try {
      final request = http.MultipartRequest('POST', url)
        ..headers['key'] = Api.secretKey
        ..fields['sellerId'] = sellerId
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['scheduledAt'] = scheduledAt.toUtc().toIso8601String();

      if (coverImage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', coverImage.path));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      log('ScheduleLive STATUS :: ${response.statusCode} BODY :: ${response.body}');
      if (response.statusCode == 200) {
        return ScheduledLiveModel.fromJson(json.decode(response.body));
      }
      throw Exception('ScheduleLive failed: ${response.statusCode}');
    } catch (e) {
      log('ScheduleLive error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<ScheduledLiveListModel> getScheduledLivesBySeller({required String sellerId}) async {
    final url = Uri.parse('${Api.baseUrl}${Api.getScheduledLivesBySeller}?sellerId=$sellerId');
    log('GetScheduledLives URL :: $url');
    try {
      final response = await http.get(url, headers: _jsonHeaders);
      log('GetScheduledLives STATUS :: ${response.statusCode}');
      if (response.statusCode == 200) {
        return ScheduledLiveListModel.fromJson(json.decode(response.body));
      }
      throw Exception('GetScheduledLives failed: ${response.statusCode}');
    } catch (e) {
      log('GetScheduledLives error: $e');
      throw Exception('Network error: $e');
    }
  }
}
