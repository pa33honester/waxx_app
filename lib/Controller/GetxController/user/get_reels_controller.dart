import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:preload_page_view/preload_page_view.dart';
import '../../../ApiModel/seller/GetReelsForUserModel.dart';
import '../../../ApiModel/user/ReelsLikeDislikeByUserModel.dart';
import '../../../utils/api_url.dart';
import '../../../utils/show_toast.dart';

class GetReelsForUserController extends GetxController {
  GetReelsForUserModel? getReelsForUser;
  ReelsLikeDislikeByUserModel? reelsLikeDislike;
  PreloadPageController preloadPageController = PreloadPageController();
  int currentPageIndex = 0;

  //----------------------------------------------------------
  PageController pageController = PageController();
  int start = 1;
  int limit = 14;
  void onChangePage(int index) async {
    currentPageIndex = index;
    update();
  }

  RxBool showLikeIcon = false.obs;
  RxBool isTextExpanded = false.obs;

  List likeDislikes = [];
  List<int?> likeCounts = [];

  List<Reel> allReels = [];

  RxBool isLoading = false.obs;
  RxBool moreLoading = false.obs;
  RxBool loadOrNot = true.obs;

  getAllReels() async {
    try {
      isLoading(true);
      loadOrNot(true);
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      // var params = {"start": "$start", "limit": "$limit", "userId": userId};
      final url = Uri.parse("${Api.baseUrl + Api.getShortForUser}?start=$start&limit=$limit&userId=$loginUserId");
      // final url = Uri.https(uri, Api.getShortForUser, params);

      log("Short Url :: $url");

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(
        url,
        headers: headers,
      );

      log('Short Response Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        allReels.clear();
        likeDislikes.clear();
        likeCounts.clear();
        final jsonResponse = json.decode(response.body);
        getReelsForUser = GetReelsForUserModel.fromJson(jsonResponse);

        allReels.addAll(getReelsForUser!.reels!);

        for (int i = 0; i < getReelsForUser!.reels!.length; i++) {
          likeDislikes.add(getReelsForUser!.reels![i].isLike);
          likeCounts.add(getReelsForUser!.reels![i].like!.toInt());
        }

        if (allReels.isEmpty) {
          loadOrNot(false);
        }
        start++;
        update();
      } else {
        throw Exception('Status code is not 200');
      }
    } catch (e) {
      Exception("API error is :: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Use when shorts pagination
  reelsPagination() async {
    try {
      moreLoading(true);
      loadOrNot(true);
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      // var params = {"start": "$start", "limit": "$limit", "userId": userId};
      final url = Uri.parse("${Api.baseUrl + Api.getShortForUser}?start=$start&limit=$limit&userId=$loginUserId");
      // final url = Uri.https(uri, Api.getShortForUser, params);
      log("Short Url :: $url");

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.get(
        url,
        headers: headers,
      );

      log('Short Response Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        getReelsForUser = GetReelsForUserModel.fromJson(jsonResponse);

        allReels.addAll(getReelsForUser!.reels!);

        for (int i = 0; i < getReelsForUser!.reels!.length; i++) {
          likeDislikes.add(getReelsForUser!.reels![i].isLike);
          likeCounts.add(getReelsForUser!.reels![i].like!.toInt());
        }
        if (getReelsForUser!.reels!.isEmpty) {
          loadOrNot(false);
          displayToast(message: "No more shorts!");
        } else {
          start++;
          update();
        }
      } else {
        throw Exception('Status code is not 200');
      }
    } catch (e) {
      Exception("API error is :: $e");
    } finally {
      moreLoading(false);
    }
  }

  likeAndDislikeByUser({required String reelId}) async {
    try {
      // String uri = Api.getDomainFromURL(Api.baseUrl);
      // var params = {
      //   "userId": userId,
      //   "reelId": reelId,
      // };

      final url = Uri.parse("${Api.baseUrl + Api.shortsLikeAndDislike}?userId=$loginUserId&reelId=$reelId");
      // final url = Uri.https(uri, Api.shortsLikeAndDislike, params);

      log('URL :: $url');

      final headers = {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        url,
        headers: headers,
      );

      log('Short Like and dislike Response Api :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        reelsLikeDislike = ReelsLikeDislikeByUserModel.fromJson(jsonResponse);
      } else {
        throw Exception('Status code is not 200');
      }
    } catch (e) {
      Exception("API error is :: $e");
    } finally {}
  }
}
