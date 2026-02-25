import 'dart:developer';

import 'package:era_shop/ApiModel/user/FollowUnfollowModel.dart';
import 'package:era_shop/ApiService/user/follow_unfollow_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

class FollowUnFollowController extends GetxController {
  FollowUnfollowModel? followUnfollow;

  followUnfollowData({required String sellerId}) async {
    try {
      var data = await FollowUnFollowApi().followUnfollow(userId: loginUserId, sellerId: sellerId);
      followUnfollow = data;
    } catch (e) {
      // Exception handling code
      log('FOLLOW UNFOLLOW: $e');
    } finally {
      log('Follow/UnFollow Api Response');
    }
  }
}
