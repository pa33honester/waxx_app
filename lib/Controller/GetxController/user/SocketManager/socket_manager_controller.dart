/*
import 'dart:developer';

import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManagerController extends GetxController {
  IO.Socket? getSocket() {
    return socket;
  }

  socketConnect() async {
    try {
      socket = IO.io(
          Api.baseUrl,
          IO.OptionBuilder().setTransports(['websocket']).setQuery(
              {"liveRoom": "liveRoom:${becomeSeller == true ? sellerId : userId}"}).build());

      socket!.connect();

      socket!.onConnect((data) {
        log("Socket Connected connected");
      });

      socket!.once("connect", (data) {
        log("Socket Connected listen");
        socket!.on("liveRoomConnect", (liveRoomConnectData) {
          log("liveRoomConnect Listen :: $liveRoomConnectData");
        });

        socket!.on("addView", (addView) {
          log("Add View :: $addView");
          SocketManage.liveWatchCount.value = addView;
        });

        socket!.on("lessView", (lessView) {
          SocketManage.liveWatchCount.value = lessView;
        });

        socket!.on("comment", (comment) {
          log("comment from listen ::  $comment");
          SocketManage.addComment(comment);
          update();
        });

        socket!.on("endLiveSeller", (liveSellingHistoryId) {
          log("End Live Seller ::  $liveSellingHistoryId");
        });

        /// add product show using socket but now api
        // socket!.on("addProduct", (addProduct) {
        //   Get.snackbar("Product data", "");
        //   log("Add product data :: $addProduct");
        //   SocketManage.sellerShowSelectedProduct.value = sellerShowSelectedProductFromJson(addProduct);
        //   update();
        // });
        //
        // socket!.on("addProductforUser", (addProductForUser) {
        //   Get.snackbar("Add Product For User data", "");
        //   log("Add Product For User data :: $addProductForUser");
        //   SocketManage.userShowSelectedProduct.value = userShowSelectedProductFromJson(addProductForUser);
        //   update();
        // });
      });

      socket!.on("error", (error) {
        log("Socket Error: $error");
      });

      socket!.on("connect_error", (error) {
        log("Socket Connection Error: $error");
      });

      socket!.on("connect_timeout", (timeout) {
        log("Socket Connection Timeout: $timeout");
      });

      socket!.on("disconnect", (reason) {
        log("Socket Disconnected: $reason");
      });

      log("Socket check :: $socket");
    } catch (e) {
      log("Socket Connection Error: $e");
    }
  }
}

class SocketManage {
  static RxInt liveWatchCount = 0.obs;
  static RxList<String> comments = <String>[].obs;

  /// For seller material
  static TextEditingController sellerCommentText = TextEditingController();

  // static Rx<SellerShowSelectedProduct?> sellerShowSelectedProduct = Rx<SellerShowSelectedProduct?>(null);
  // static SellerShowSelectedProduct? get sellerShowSelectedProductValue => sellerShowSelectedProduct.value;

  /// For user material
  static TextEditingController userCommentText = TextEditingController();

  static void addComment(String comment) {
    comments.add(comment);
    log("Comments: $comments");
  }

// static Rx<UserShowSelectedProduct?> userShowSelectedProduct = Rx<UserShowSelectedProduct?>(null);
// static UserShowSelectedProduct? get userShowSelectedProductValue => userShowSelectedProduct.value;
}
*/
