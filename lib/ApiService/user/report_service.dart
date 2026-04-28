import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/report_reason_model.dart';
import 'package:waxxapp/ApiModel/user/report_reel_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportService extends GetxService {
  Future<ReportReelModel> reportReel({
    required String userId,
    required String reelId,
    required String description,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.reportReel);

    final body = jsonEncode({'userId': userId, 'reelId': reelId, 'description': description});

    log("PAYLOAD :: $body");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('Report Reel API URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ReportReelModel.fromJson(jsonResponse);
    } else {
      throw Exception('Review is failed');
    }
  }

  Future<ReportReelModel> reportLive({
    required String userId,
    required String liveSellingHistoryId,
    required String description,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.reportLive);

    final body = jsonEncode({
      'userId': userId,
      'liveSellingHistoryId': liveSellingHistoryId,
      'description': description,
    });

    log("PAYLOAD :: $body");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('Report Live API URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ReportReelModel.fromJson(jsonResponse);
    } else {
      throw Exception('Report live failed');
    }
  }

  Future<ReportReasonModel> getReportReason() async {
    final url = Uri.parse(Api.baseUrl + Api.getReportreason);

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);

    log('Report Reason API URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ReportReasonModel.fromJson(jsonResponse);
    } else {
      throw Exception('Report is failed');
    }
  }
}
