import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:waxxapp/utils/api_url.dart';
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

    // Log file size for debugging
    log("Video file size :: ${(video.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB");

    var res1 = await request.send().timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        throw Exception('Upload timed out. The video file may be too large or your connection is slow.');
      },
    );
    var response = await http.Response.fromStream(res1);

    log('Reels add By Seller :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UploadReelModel.fromJson(jsonResponse);
    } else {
      throw Exception('Upload Reels failed with status ${response.statusCode}: ${response.body}');
    }
  }
}
