import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/main.dart';
import 'package:era_shop/seller_pages/live_page/controller/live_controller.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'database.dart';

io.Socket? socket;

class SocketServices {
  // io.Socket? getSocket() => socket;
  static bool _isListenersSetup = false; // Add this flag

  io.Socket? getSocket() => socket;

  static bool isLiveRunning = false;
  static RxInt liveWatchCount = 0.obs;
  static RxList mainLiveComments = [].obs;
  static ScrollController scrollController = ScrollController();
  static TextEditingController sellerCommentText = TextEditingController();
  static TextEditingController userCommentText = TextEditingController();

  static Future<void> socketConnect() async {
    log("Socket Connect>>>>>${Database.isSeller}");
    log("Socket Connect>>>>>${Database.sellerId}");
    log("Socket Connect>>>>>${Database.loginUserId}");

    try {
      // Disconnect existing socket if connected
      if (socket != null) {
        _clearAllListeners(); // Clear existing listeners
        socket!.disconnect();
        socket = null;
      }

      socket = io.io(
        Api.baseUrl,
        io.OptionBuilder().setTransports(['websocket']).setQuery({"liveRoom": "liveRoom:${Database.loginUserId}"}).build(),
      );

      socket!.connect();
      liveWatchCount.value = 0;

      socket!.onConnect((data) {
        log("Socket Connected");
        if (!_isListenersSetup) {
          _setupEventListeners(); // Setup listeners only once
          _isListenersSetup = true;
        }
      });

      socket!.on("error", (error) {
        log("Socket Listen => Socket Error : $error");
      });

      socket!.on("connect_error", (error) {
        log("Socket Listen => Socket Connection Error : $error");
      });

      socket!.on("connect_timeout", (timeout) {
        log("Socket Listen => Socket Connection Timeout : $timeout");
      });

      socket!.on("disconnect", (reason) {
        log("Socket Listen => Socket Disconnected : $reason");
        _isListenersSetup = false; // Reset flag on disconnect
      });

      log("Socket Listen => Socket Connected : ${socket?.connected}");
      socket!.onDisconnect((_) {
        log('Socket disconnected');
        // _isListenersSetup = false; // Reset flag
        // if (LivePageRouteObserver.isOnLivePage) {
        //   _attemptReconnect();
        // }
      });
    } catch (e) {
      log("Socket Listen => Socket Connection Error: $e");
    }
  }

  // Separate method to setup event listeners
  static void _setupEventListeners() {
    if (socket == null) return;

    log("Setting up socket event listeners");

    // >>>>> >>>>> >>>>> >>>>> Socket Listen Method <<<<< <<<<< <<<<< <<<<<

    socket!.on("liveRoomConnect", (liveRoomConnectData) {
      log("Socket Listen => Live Room Connect : $liveRoomConnectData");
    });

    socket!.on("addView", (addView) {
      liveWatchCount.value = addView;
      log("Socket Listen => Add View : $addView");
    });

    socket!.on("lessView", (lessView) {
      liveWatchCount.value = lessView;
      log("Socket Listen => Less View : $lessView");
    });

    socket!.on("comment", (comment) {
      log("Socket Listen => Add New Comment : $comment");
      onGetNewComment(comment: comment);
    });

    socket!.on("endLiveSeller", (liveSellingHistoryId) {
      log("Socket Listen => End Live Seller : $liveSellingHistoryId");
      onEndLiveSeller(liveSellingHistoryId: liveSellingHistoryId);
    });

    socket!.on("liveSessionInfo", (liveData) {
      Utils.showLog("Socket Listen => liveUserInfoResponse : $liveData");

      try {
        if (liveData is String && liveData.contains("The live stream has ended. Disconnecting...")) {
          Utils.showLog("Live stream session ended");
          onLiveStreamEnded();
          return;
        }

        Map<String, dynamic> parsedData;

        if (liveData is String) {
          parsedData = jsonDecode(liveData);
        } else if (liveData is Map) {
          parsedData = Map<String, dynamic>.from(liveData);
        } else {
          Utils.showLog("Socket Listen => Get User Live Complete Error: Unexpected data type");
          return;
        }

        onLiveUserInfoResponse(
          liveData: parsedData,
        );
      } catch (e) {
        Utils.showLog("Socket Listen => Get User Live Complete Parse Error: $e");
      }
    });
  }

  // Method to clear all event listeners
  static void _clearAllListeners() {
    if (socket == null) return;

    log("Clearing all socket event listeners");

    // Clear all event listeners
    socket!.off("liveRoomConnect");
    socket!.off("addView");
    socket!.off("lessView");
    socket!.off("comment");
    socket!.off("endLiveSeller");
    socket!.off("initiateAuction");
    socket!.off("auctionError");
    socket!.off("announceTopBidPlaced");
    socket!.off("declareAuctionResult");
    socket!.off("notifyPaymentDue");
    socket!.off("handleAuctionExpiryAndRelist");
    socket!.off("auctionExpiryHandled");
    socket!.off("liveSessionInfo");
  }

  // static void _attemptReconnect() {
  //   if (!LivePageRouteObserver.isOnLivePage) return;
  //
  //   log('Attempting to reconnect...');
  //   Future.delayed(Duration(seconds: 2), () {
  //     if (LivePageRouteObserver.isOnLivePage && socket?.connected != true) {
  //       log("Socket is not connected, reconnecting...");
  //       socketConnect();
  //     }
  //   });
  // }

  static int _liveScreenCount = 0;
  static bool get isOnLivePage => _liveScreenCount > 0;

  static void registerLiveScreen() {
    _liveScreenCount++;
    log('Live screen registered, count: $_liveScreenCount');
  }

  static void unregisterLiveScreen() {
    if (_liveScreenCount > 0) {
      _liveScreenCount--;
    }
    log('Live screen unregistered, count: $_liveScreenCount');
  }

  // >>>>> >>>>> >>>>> >>>>> Socket Emit Method <<<<< <<<<< <<<<< <<<<<

  static Future<void> onLiveRoomConnect({
    required String loginUserId,
    required String liveHistoryId,
  }) async {
    final liveRoomData = jsonEncode({
      "userId": loginUserId,
      "liveSellingHistoryId": liveHistoryId,
    });

    log("Socket Emit => Live Room Data: $liveRoomData");
    if (socket != null && socket!.connected) {
      socket?.emit("liveRoomConnect", liveRoomData);
      log("Socket Emit => Live Room Connected.");
    } else {
      log("Socket Not Connected");
    }
  }

  static Future<void> onAddView({
    required String loginUserId,
    required String liveHistoryId,
  }) async {
    isLiveRunning = true;

    final userData = jsonEncode({
      "userId": loginUserId,
      "liveSellingHistoryId": liveHistoryId,
    });

    log("Socket Emit => New User Join Live Room: $userData");
    if (socket != null && socket!.connected) {
      socket?.emit("addView", userData);
      log("Socket Emit => New User Join Live Room");
    } else {
      log("Socket Not Connected");
    }
  }

  static Future<void> onLessView({
    required String loginUserId,
    required String liveHistoryId,
  }) async {
    final userData = jsonEncode({
      "userId": loginUserId,
      "liveSellingHistoryId": liveHistoryId,
    });
    log("Socket Emit => User Exit Live Room: $userData");
    if (socket != null && socket!.connected) {
      socket?.emit("lessView", userData);
      log("Socket Emit => User Exit Live Room");
    } else {
      log("Socket Not Connected");
    }
  }

  static Future<void> onLiveChat({
    required String loginUserId,
    required String liveHistoryId,
    required String commentText,
    String? userName,
    String? userImage,
  }) async {
    final commentData = jsonEncode({
      "userId": loginUserId,
      "liveSellingHistoryId": liveHistoryId,
      "comment": commentText,
      if (userName != null) "userName": userName,
      if (userImage != null) "userImage": userImage,
    });
    log("Socket Emit => Comment Data: $commentData");
    if (socket != null && socket!.connected) {
      socket!.emit("comment", commentData);
      log("Socket Emit => User Add New Comment");
    } else {
      log("Socket Not Connected");
    }
  }

  static Future<void> onLiveRoomExit({required String liveHistoryId, required bool isHost}) async {
    Utils.showLog("Socket Emit => Live Room ");
    log("Socket Emit Exit Live Room ${liveHistoryId}${isHost}");
    if (isHost) {
      final endLive = jsonEncode({"liveSellingHistoryId": liveHistoryId});
      log("Socket Emit => Live Room Disconnected: $endLive");
      if (socket != null && socket!.connected) {
        socket?.emit("endLiveSeller", endLive);
        Utils.showLog("Socket Emit => Live Room Disconnected.");
      } else {
        Utils.showLog("Socket Not Connected");
      }
    }
  }

  static Future<void> onGetUserLiveDetails({
    required String liveHistoryId,
  }) async {
    final liveUserData = jsonEncode({
      "liveHistoryId": liveHistoryId,
    });

    if (socket != null && socket!.connected) {
      socket?.emit("fetchLiveBroadcastDetails", liveUserData);
      Utils.showLog("Socket Emit => Get User Live Action: $liveUserData");
    } else {
      Utils.showLog("Socket Not Connected");
    }
  }

  static Future<void> onFollowCountChange({
    required String liveHistoryId,
  }) async {
    final followUserData = jsonEncode({
      "liveHistoryId": liveHistoryId,
    });

    if (socket != null && socket!.connected) {
      Utils.showLog("Socket Emit => Get User Live Action: $followUserData");
      socket?.emit("followCountChange", followUserData);
    } else {
      Utils.showLog("Socket Not Connected");
    }
  }
  // >>>>> >>>>> >>>>> >>>>> Socket Listen Data Set Method <<<<< <<<<< <<<<< <<<<<

  static Future<void> onGetNewComment({required String comment}) async {
    mainLiveComments.add(comment);
    log("Comments: $mainLiveComments");
    await onScrollDown();
  }

  static Future<void> onEndLiveSeller({required String liveSellingHistoryId}) async {
    log("Live seller ended: $liveSellingHistoryId");

    if (isLiveRunning) {
      isLiveRunning = false;
      liveWatchCount.value = 0;

      // Navigate back or show appropriate UI
      if (Get.context != null) {
        Get.back();
      }
    }
  }

  static void onLiveUserInfoResponse({required Map<String, dynamic> liveData}) {
    try {
      Utils.showLog("Live User Info Response => $liveData");

      Get.find<LiveController>().handleLiveUserInfoResponse(liveData);
    } catch (e) {
      Utils.showLog("Handle Live User Info Response Error => $e");
    }
  }

  static void onLiveStreamEnded() {
    try {
      Utils.showLog("Handling live stream end...");

      // Get the LiveController and call the end session method
      Get.find<LiveController>().handleLiveStreamEnd();
    } catch (e) {
      Utils.showLog("Handle Live Stream End Error => $e");
    }
  }

  static Future<void> onScrollDown() async {
    try {
      await 10.milliseconds.delay();
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
        await 10.milliseconds.delay();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    } catch (e) {
      log("Scroll Down Failed => $e");
    }
  }

  // Method to dispose resources
  static void dispose() {
    sellerCommentText.dispose();
    userCommentText.dispose();
    scrollController.dispose();
  }

  // Method to disconnect socket
  static void disconnect() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      log("Socket Disconnected");
    }
  }
}
