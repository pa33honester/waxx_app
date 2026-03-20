import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/SellerFollowersModel.dart';
import 'package:waxxapp/ApiModel/seller/SellerReelsModel.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/model/fetch_seller_profile_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class FetchSellerProfileApi {
  static int startPagination = 1;
  static int limitPagination = 10;

  static Future<FetchSellerProfileModel?> callApi({required String sellerId, required String loginUserId}) async {
    Utils.showLog("Fetch Seller Profile Api Calling...");

    final uri = Uri.parse("${Api.fetchSellerProfile}?sellerId=$sellerId&loggedInUserId=$loginUserId");
    // final uri = Uri.parse("${Api.fetchSellerProfile}?sellerId=65c06f09387a7c37496871a0&loggedInUserId=65bc7549bf16286a1e34b33d");

    Utils.showLog("Fetch Seller Profile Api Url => $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Fetch Seller Profile Api Response => ${response.body}");

        return FetchSellerProfileModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Fetch Seller Profile Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Fetch Seller Profile Api Error => $error");
    }
    return null;
  }

  static Future<SellerReelsModel?> sellerReelsApi({required String sellerId}) async {
    Utils.showLog("Fetch Seller Reels Api Calling...");

    final uri = Uri.parse("${Api.fetchSellerReels}?sellerId=$sellerId&start=$startPagination&limit=$limitPagination");
    // final uri = Uri.parse("${Api.fetchSellerProfile}?sellerId=65c06f09387a7c37496871a0&loggedInUserId=65bc7549bf16286a1e34b33d");

    Utils.showLog("Fetch Seller Reels Api Url => $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Fetch Seller Reels Api Response => ${response.body}");

        return SellerReelsModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Fetch Seller Reels Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Fetch Seller Reels Api Error => $error");
    }
    return null;
  }

  static Future<SellerFollowersModel?> sellerFollowersApi({required String sellerId}) async {
    Utils.showLog("Fetch Seller Followers Api Calling...");

    final uri = Uri.parse("${Api.fetchSellerFollowers}?sellerId=$sellerId");
    // final uri = Uri.parse("${Api.fetchSellerProfile}?sellerId=65c06f09387a7c37496871a0&loggedInUserId=65bc7549bf16286a1e34b33d");

    Utils.showLog("Fetch Seller Followers Api Url => $uri");

    final headers = {"key": Api.secretKey};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Fetch Seller Followers Api Response => ${response.body}");

        return SellerFollowersModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Fetch Seller Followers Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Fetch Seller Followers Api Error => $error");
    }
    return null;
  }
}
