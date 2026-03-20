import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/CreateReviewModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewApi extends GetxService {
  Future<CreateReviewModel> enterReview({
    required String review,
    required String userId,
    required String productId,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.reviewCreate);
    log("Review API :: $url");
    final body = jsonEncode({'review': review, 'userId': userId, 'productId': productId});
    log("Review API :: $body");
    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers, body: body);

    log('Review Status code :: ${response.statusCode} Body :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return CreateReviewModel.fromJson(jsonResponse);
    } else {
      throw Exception('Review is failed');
    }
  }
}
