import 'dart:async';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class LiveController extends GetxController {
  bool isFrontCamera = true;
  bool isFlashOn = false;
  bool isMicOn = true;
  Timer? liveTimer;
  String userId = "";
  String sellerId = "";
  String roomId = "";
  String Id = "";
  String image = "";
  String name = "";
  String userName = "";
  List<SelectedProduct> liveSelectedProducts = []; // List<Map<String, dynamic>>
  String businessName = "";
  String businessTag = "";
  int liveType = 0;
  bool isFollow = false;
  bool isHost = false;
  bool isProfileImageBanned = false;
  // bool isSelectProduct = false;

  int countTime = 0;
  bool isLivePage = false;

  LiveSeller? updatedLiveUserList;

  bool _isCommentVisible = false;
  bool get isCommentVisible => _isCommentVisible;

  TextEditingController commentController = TextEditingController();

  // Method to toggle comment visibility with animation
  void toggleCommentVisibility(bool show) {
    _isCommentVisible = show;
    update(["idUserPlaceBid"]);
  }

  Future<void> onSwitchMic() async {
    isMicOn = !isMicOn;
    ZegoExpressEngine.instance.enableAudioCaptureDevice(isMicOn);
    update(["onSwitchMic"]);
  }

  Future<void> onSwitchCamera() async {
    Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
    if (isFrontCamera) {
      ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
      isFrontCamera = !isFrontCamera;
      await 200.milliseconds.delay();
      ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
    } else {
      ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
      isFrontCamera = !isFrontCamera;
      await 200.milliseconds.delay();
      ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
    }
    Get.back(); // Stop Loading...
  }

  Future<void> onSendComment() async {
    if (commentController.text.trim().isNotEmpty) {
      SocketServices.onLiveChat(
        loginUserId: userId,
        liveHistoryId: roomId,
        userName: "${Database.fetchLoginUserProfileModel?.user?.firstName} ${Database.fetchLoginUserProfileModel?.user?.lastName}" ?? "",
        userImage: Database.fetchLoginUserProfileModel?.user?.image ?? "",
        commentText: commentController.text,
      );
      commentController.clear();
    }
  }

  Future<void> onClickFollow() async {
    if (userId != 0) {
      isFollow = !isFollow;
      update(["onClickFollow"]);
      // businessName != "" ? await SellerFollowUnfollowApi.callApi(loginUserId: Database.loginUserId, sellerId: userId) : await FollowUnfollowApi.callApi(loginUserId: Database.loginUserId, userId: userId);
      if (isFollow) {
        SocketServices.onGetUserLiveDetails(
          liveHistoryId: roomId,
        );
      }
    } else {
      Utils.showToast(St.txtYouCantFollowYourOwnAccount.tr);
    }
  }

  void onChangeTime() {
    isLivePage = true;

    liveTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (isLivePage) {
          countTime++;
          // Utils.showLog("Live Streaming Time => ${onConvertSecondToHMS(countTime)}");
          update(["onChangeTime"]);
        } else {
          timer.cancel();
          countTime = 0;
          update(["onChangeTime"]);
        }
      },
    );
  }

  String onConvertSecondToHMS(int totalSeconds) {
    Duration duration = Duration(seconds: totalSeconds);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String time = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

    return time;
  }

  @override
  void onInit() {
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.firstName}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.lastName}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.isSeller}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.image}");

    super.onInit();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void handleLiveUserInfoResponse(data) {
    log("GetLiveUserInfo Socket Listen => $data");

    List<LiveSeller> users = <LiveSeller>[];
    if (data is Map<String, dynamic>) {
      // Single user case
      users = [LiveSeller.fromJson(data)];
      // Process the user...
    } else if (data is List) {
      // Multiple users case
      users = data.map((userJson) => LiveSeller.fromJson(userJson)).toList();
      // Process the users...
    } else {
      log("GetLiveUserInfo Socket Listen => Invalid data format: $data");
      return; // Exit if data is not in expected format
    }

    updatedLiveUserList = users.isNotEmpty ? users.first : null;
    log("GetLiveUserInfo Socket Listen updatedLiveUserList => ${updatedLiveUserList?.toJson()}");
    update(["onUpdateMultiLive", "idShare"]);
  }

  void handleLiveStreamEnd() {
    Utils.showLog("Live stream session ended - cleaning up...");

    // Clear the live user data
    updatedLiveUserList = null;
    Get.back();
    // Update UI to show session ended
    update(["onLiveStreamEnded", "onUpdateMultiLive", "idShare"]);

    // You can add additional cleanup logic here:
    // - Navigate to a different screen
    // - Show a dialog/snackbar to user
    // - Disconnect socket if needed
    // - Clear any other live-related data

    // Example: Show snackbar
    Utils.showToast(
      "Live Stream Ended",
    );
    Utils.showToast("Live Stream Ended The live Stream has ended");

    // Example: Navigate back or to home
    // Get.back(); // or Get.offAllNamed('/home');
  }
}
