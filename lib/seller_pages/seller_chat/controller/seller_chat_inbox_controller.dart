import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:waxxapp/seller_pages/seller_chat/model/seller_chat_inbox_model.dart';
import 'package:waxxapp/seller_pages/seller_chat/service/seller_chat_inbox_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';

class SellerChatInboxController extends GetxController {
  final RxList<SellerChatInboxTile> tiles = <SellerChatInboxTile>[].obs;
  final RxBool isLoading = true.obs;

  Worker? _inboxWorker;

  @override
  void onInit() {
    super.onInit();
    SocketServices.onProductChatInboxJoin(sellerId: Database.sellerId);
    _inboxWorker = ever<dynamic>(SocketServices.productChatInboxStream, _onInboxUpdated);
    _load();
  }

  @override
  void onClose() {
    _inboxWorker?.dispose();
    SocketServices.onProductChatInboxLeave(sellerId: Database.sellerId);
    super.onClose();
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    isLoading.value = true;
    try {
      final result = await SellerChatInboxService.fetchInbox(sellerId: Database.sellerId);
      tiles.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void _onInboxUpdated(dynamic raw) {
    if (raw == null) return;
    try {
      final map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : (raw is Map ? Map<String, dynamic>.from(raw) : null);
      if (map == null) return;

      final convId = map["conversationId"]?.toString() ?? "";
      if (convId.isEmpty) return;

      final idx = tiles.indexWhere((t) => t.id == convId);
      if (idx < 0) {
        // New conversation we haven't loaded yet — refresh from server.
        _load();
        return;
      }

      final tile = tiles[idx];
      final updated = SellerChatInboxTile(
        id: tile.id,
        productSnapshot: tile.productSnapshot,
        buyerInfo: tile.buyerInfo,
        convStatus: tile.convStatus,
        unreadBySeller: map["unreadBySeller"] as int? ?? tile.unreadBySeller,
        lastActivityAt: map["lastActivityAt"] != null
            ? DateTime.tryParse(map["lastActivityAt"].toString()) ?? tile.lastActivityAt
            : tile.lastActivityAt,
        lastMessage: map["lastMessage"] != null
            ? SellerChatLastMessage(
                senderType: map["senderType"]?.toString(),
                text: map["lastMessage"]?.toString(),
                createdAt: DateTime.now(),
              )
            : tile.lastMessage,
      );

      tiles[idx] = updated;
      // Re-sort so most recent conversation floats to top.
      tiles.sort((a, b) =>
          (b.lastActivityAt ?? DateTime(0)).compareTo(a.lastActivityAt ?? DateTime(0)));
      tiles.refresh();
    } catch (e) {
      log("SellerChatInboxController._onInboxUpdated error: $e");
    }
  }

  void openConversation(SellerChatInboxTile tile) {
    Get.toNamed("/ProductChat", arguments: {
      "conversationId": tile.id ?? "",
      "productId": "",
      "sellerId": Database.sellerId,
      "buyerId": tile.buyerInfo?.id ?? "",
      "role": "seller",
    });
  }
}
