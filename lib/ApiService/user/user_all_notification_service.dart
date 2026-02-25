import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/get_all_notifications_model.dart';
import '../../utils/api_url.dart';

class GetAllNotifications extends GetxService {
  Future<GetAllNotificationsModel?> getNotification() async {
    try {
      // final params = {"userId": userId};
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      // final url = Uri.https(uri, Api.allNotificationList, params);
      final url = Uri.parse("${Api.baseUrl + Api.allNotificationList}?userId=$loginUserId");

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(url, headers: headers);

      log('NOTIFICATION STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return GetAllNotificationsModel.fromJson(jsonResponse);
      } else {
        throw Exception('Status code is not 200');
      }
    } catch (e) {
      log("Notification :: $e");
    }
    return null;
  }
}
