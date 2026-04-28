import 'dart:async';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/ApiModel/user/report_reason_model.dart';
import 'package:waxxapp/ApiModel/user/report_reel_model.dart';
import 'package:waxxapp/ApiService/user/report_service.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
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

  // Local heart toggle for the buyer-side live page. Server-side persistence
  // is intentionally skipped — live likes are ephemeral the way TikTok / IG
  // Live treat them. Tap flips the heart and the icon-only state updates.
  bool isLiveLiked = false;

  // Buyer-side: muting the incoming Zego stream so the user can watch silently
  // without affecting other viewers. The streamID we mute against lives on
  // [remoteStreamID]; the live view sets it when `_startPlayStream` fires and
  // clears it on cleanup. Rx so the icon updates without an explicit `update`
  // ping from inside the Zego callbacks.
  RxBool isStreamMuted = false.obs;
  String? remoteStreamID;

  // Report-this-live bottom sheet state. Reasons are fetched once on
  // first open via [getReportReason]; [selectedReport] tracks the
  // currently-checked option.
  ReportReasonModel? reportReasonModel;
  Report? selectedReport;
  ReportReelModel? reportLiveModel;
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
    update(["onSwitchCamera"]);
  }

  /// Buyer-side toggle: mutes / unmutes the incoming live audio for *this*
  /// viewer only. No-ops if we don't yet have a [remoteStreamID] (i.e. the
  /// host's stream hasn't been received yet) — the icon still flips so the
  /// user has feedback, and the next playback cycle will respect the state.
  void onToggleStreamMute() {
    isStreamMuted.value = !isStreamMuted.value;
    final id = remoteStreamID;
    if (id != null && id.isNotEmpty) {
      ZegoExpressEngine.instance.mutePlayStreamAudio(id, isStreamMuted.value);
    }
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

  /// Called by the socket layer when the backend emits
  /// `selectedProductsUpdated` (host added a product mid-stream). Replaces
  /// the in-memory list and pings GetBuilder so every widget watching
  /// `liveSelectedProducts` repaints.
  void onSelectedProductsUpdated(Map data) {
    final raw = data['selectedProducts'];
    if (raw is! List) return;
    try {
      final next = raw
          .whereType<Map>()
          .map((e) => SelectedProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      liveSelectedProducts = next;
      update();
    } catch (e) {
      // Bad shape — leave the existing list alone rather than empty it.
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

  void onToggleLiveLike() {
    if (roomId.isEmpty) return;
    // Toggle the local heart immediately; the room-wide running total is
    // owned by the backend and broadcast via the `liveLikeCount` socket
    // event. Optimistically nudge the local mirror so the number doesn't
    // visually lag a round-trip behind the tap.
    isLiveLiked = !isLiveLiked;
    if (isLiveLiked) {
      SocketServices.liveLikeCount.value += 1;
      SocketServices.onLiveLike(liveHistoryId: roomId);
    }
    update(["onToggleLiveLike"]);
  }

  Future<void> getReportReason() async {
    try {
      final data = await ReportService().getReportReason();
      reportReasonModel = data;
      update(["onReportReasonsLoaded"]);
    } catch (e) {
      log('LiveController.getReportReason error: $e');
    }
  }

  void selectReportReason(Report? report) {
    selectedReport = report;
    update();
  }

  Future<void> reportLive({
    required String liveSellingHistoryId,
    required String description,
  }) async {
    try {
      final data = await ReportService().reportLive(
        userId: loginUserId,
        liveSellingHistoryId: liveSellingHistoryId,
        description: description,
      );
      reportLiveModel = data;
      Utils.showToast(reportLiveModel?.message ?? '');
      if (reportLiveModel?.status == true) {
        selectedReport = null;
        update();
        Get.back();
      }
    } catch (e) {
      log('LiveController.reportLive error: $e');
    }
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
