import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/upcoming_lives_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class UpcomingLivesService {
  final _headers = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<UpcomingLivesModel> getUpcomingLives({required String userId}) async {
    final url = Uri.parse('${Api.baseUrl}${Api.getUpcomingLivesForUser}?userId=$userId');
    log('GetUpcomingLives URL :: $url');
    try {
      final response = await http.get(url, headers: _headers);
      log('GetUpcomingLives STATUS :: ${response.statusCode}');
      if (response.statusCode == 200) {
        return UpcomingLivesModel.fromJson(json.decode(response.body));
      }
      log('GetUpcomingLives failed: ${response.statusCode}');
      return UpcomingLivesModel(status: false, data: []);
    } catch (e) {
      log('GetUpcomingLives error: $e');
      return UpcomingLivesModel(status: false, data: []);
    }
  }

  Future<bool> setReminder({required String userId, required String scheduleId}) async {
    final url = Uri.parse(Api.baseUrl + Api.setLiveReminder);
    final body = jsonEncode({'userId': userId, 'scheduleId': scheduleId});
    log('SetLiveReminder URL :: $url');
    try {
      final response = await http.post(url, headers: _headers, body: body);
      log('SetLiveReminder STATUS :: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      log('SetLiveReminder error: $e');
      return false;
    }
  }

  Future<bool> cancelReminder({required String userId, required String scheduleId}) async {
    final url = Uri.parse(Api.baseUrl + Api.cancelLiveReminder);
    final body = jsonEncode({'userId': userId, 'scheduleId': scheduleId});
    log('CancelLiveReminder URL :: $url');
    try {
      final response = await http.post(url, headers: _headers, body: body);
      log('CancelLiveReminder STATUS :: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      log('CancelLiveReminder error: $e');
      return false;
    }
  }
}
