import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/scheduled_live_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class ScheduleLiveService {
  final _headers = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<ScheduledLiveModel> scheduleLive({
    required String sellerId,
    required String title,
    required String description,
    required DateTime scheduledAt,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.scheduleLive);
    final body = jsonEncode({
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'scheduledAt': scheduledAt.toIso8601String(),
    });
    log('ScheduleLive URL :: $url\nBody :: $body');
    try {
      final response = await http.post(url, headers: _headers, body: body);
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
      final response = await http.get(url, headers: _headers);
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
