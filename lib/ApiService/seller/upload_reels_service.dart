import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ApiModel/seller/UploadReelModel.dart';

class UploadReelsApi extends GetxService {
  Future<UploadReelModel> uploadReelApi({
    required String sellerId,
    required List<String> productId,
    required File video,
    required String thumbnailPath,
    required String description,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.uploadShort);
    var request = http.MultipartRequest("POST", url);
    log("video url :: $url");
    if (video.isBlank != true) {
      log("video path :: ${video.path}");
      var addImage = await http.MultipartFile.fromPath('video', video.path);
      request.files.add(addImage);
    }

    log("Service in thumbnail path :: $thumbnailPath");
    var addThumbnail = await http.MultipartFile.fromPath('thumbnail', thumbnailPath);
    request.files.add(addThumbnail);

    request.headers.addAll({
      "key": Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    });

    Map<String, String> body = {
      'sellerId': sellerId,
      'productIds': json.encode(productId),
      'description': description,
    };
    log("Upload reel by seller :: $body");

    request.fields.addAll(body);
    var res1 = await request.send();
    var response = await http.Response.fromStream(res1);

    if (response.statusCode == 200) {
      log('Reels add By Seller :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');
      final jsonResponse = json.decode(response.body);
      return UploadReelModel.fromJson(jsonResponse);
    } else {
      throw Exception('Upload Reels failed');
    }
  }
}
