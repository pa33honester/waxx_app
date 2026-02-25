import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/user/CreateRatingModel.dart';

class CreateRatingService extends GetxService {
  Future<CreateRatingModel> createRating({
    required String productId,
    required String userId,
    required RxDouble rating,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   'rating': rating.toString(),
    //   'userId': userId,
    //   'productId': productId
    // };

    final url = Uri.parse(
        "${Api.baseUrl + Api.ratingAdd}?rating=${rating.toString()}&userId=$userId&productId=$productId");
    // final url = Uri.https(uri, Api.ratingAdd, params);

    // final body = jsonEncode({'rating': rating, 'userId': userId, 'productId': productId});

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers);

    log('Rating Status code :: ${response.statusCode} \nBody :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CreateRatingModel.fromJson(jsonResponse);
    } else {
      throw Exception('Rating is failed');
    }
  }
}
