import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/ApiModel/user/FollowUnfollowModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FollowUnFollowApi extends GetxService {
  Future<FollowUnfollowModel> followUnfollow({
    required String userId,
    required String sellerId,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.followUnfollow);

    final body = jsonEncode({'userId': userId, 'sellerId': sellerId});

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('FOLLOW/UNFOLLOW API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return FollowUnfollowModel.fromJson(jsonResponse);
    } else {
      throw Exception('Review is failed');
    }
  }
}
