import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/product_chat/model/product_chat_model.dart';
import 'package:waxxapp/user_pages/product_chat/service/product_chat_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';

class ProductChatController extends GetxController {
  final RxList<ProductChatMessage> messages = <ProductChatMessage>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSending = false.obs;
  final RxString filterError = "".obs;
  final Rx<ProductChatSnapshot?> productSnapshot = Rx<ProductChatSnapshot?>(null);
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? _conversationId;
  String? _productId;
  String? _sellerId;
  String? _buyerId;
  String _role = "buyer"; // "buyer" | "seller"
  String get role => _role;

  Worker? _msgWorker;
  Worker? _readWorker;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _productId = args['productId'] as String?;
    _sellerId = args['sellerId'] as String?;
    _buyerId = (args['buyerId'] as String?)?.isNotEmpty == true
        ? args['buyerId'] as String
        : Database.loginUserId;
    _role = (args['role'] as String?) ?? "buyer";
    // Seller inbox tap can pass a pre-known conversationId to skip getOrCreate.
    _conversationId = args['conversationId'] as String?;

    _msgWorker = ever<dynamic>(SocketServices.productChatMessageStream, _onSocketMessage);
    _readWorker = ever<dynamic>(SocketServices.productChatReadStream, _onRead);

    _bootstrap();
  }

  @override
  void onClose() {
    _msgWorker?.dispose();
    _readWorker?.dispose();
    if (_conversationId != null && _conversationId!.isNotEmpty) {
      SocketServices.onProductChatLeave(conversationId: _conversationId!);
    }
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    try {
      // If conversationId is pre-known (seller tapping from inbox), we still
      // call getOrCreate — it's idempotent and marks messages as read server-side.
      final buyerId = _buyerId ?? Database.loginUserId;
      final sellerId = _sellerId ?? "";
      final productId = _productId ?? "";

      if (buyerId.isEmpty || sellerId.isEmpty || productId.isEmpty) {
        // Missing args — bail gracefully.
        return;
      }

      final conv = await ProductChatService.getOrCreateConversation(
        buyerId: buyerId,
        sellerId: sellerId,
        productId: productId,
      );
      if (conv == null) return;

      _conversationId = conv.id;
      productSnapshot.value = conv.productSnapshot;
      messages.assignAll(conv.messages ?? const <ProductChatMessage>[]);

      if (_conversationId != null && _conversationId!.isNotEmpty) {
        SocketServices.onProductChatJoin(
          conversationId: _conversationId!,
          userId: _role == "buyer" ? buyerId : sellerId,
          role: _role,
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      log("ProductChatController bootstrap error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _onSocketMessage(dynamic raw) {
    if (raw == null) return;
    final msg = ProductChatMessage.tryParseSocketPayload(raw);
    if (msg == null) return;
    if (msg.id != null && messages.any((m) => m.id == msg.id)) return;
    messages.add(msg);
    // If the message came from the other side, mark it read live.
    if (msg.senderType != _role &&
        _conversationId != null &&
        _conversationId!.isNotEmpty) {
      SocketServices.onProductChatMarkRead(
        conversationId: _conversationId!,
        readerRole: _role,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _onRead(dynamic raw) {
    if (raw == null) return;
    try {
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      if (_conversationId != null &&
          (map["conversationId"]?.toString() ?? "") != _conversationId) return;
      // The other side read our messages — flip our own bubbles to read.
      final readerRole = map["readerRole"]?.toString() ?? "";
      if (readerRole == _role) { return; } // we read our own — ignore
      var changed = false;
      for (var i = 0; i < messages.length; i++) {
        final m = messages[i];
        if (m.senderType == _role && m.isRead != true) {
          messages[i] = ProductChatMessage(
            id: m.id,
            senderType: m.senderType,
            senderId: m.senderId,
            senderName: m.senderName,
            senderImage: m.senderImage,
            text: m.text,
            isRead: true,
            createdAt: m.createdAt,
          );
          changed = true;
        }
      }
      if (changed) messages.refresh();
    } catch (_) {}
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isSending.value) return;
    filterError.value = "";
    isSending.value = true;

    final placeholder = ProductChatMessage(
      id: "local_${DateTime.now().millisecondsSinceEpoch}",
      senderType: _role,
      senderName: "You",
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );
    messages.add(placeholder);
    inputController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      ProductChatMessage? persisted;
      if (_role == "buyer") {
        persisted = await ProductChatService.sendBuyerMessage(
          conversationId: _conversationId ?? "",
          buyerId: _buyerId ?? Database.loginUserId,
          text: text,
        );
      } else {
        persisted = await ProductChatService.sendSellerMessage(
          conversationId: _conversationId ?? "",
          sellerId: _sellerId ?? Database.sellerId,
          text: text,
        );
      }
      final idx = messages.indexWhere((m) => m.id == placeholder.id);
      if (persisted != null && idx >= 0) {
        messages[idx] = persisted;
      } else if (persisted == null) {
        if (idx >= 0) messages.removeAt(idx);
      }
    } on ProductChatFilterException catch (e) {
      final idx = messages.indexWhere((m) => m.id == placeholder.id);
      if (idx >= 0) messages.removeAt(idx);
      inputController.text = text;
      filterError.value = e.message;
    } catch (e) {
      log("ProductChatController.sendMessage error: $e");
      final idx = messages.indexWhere((m) => m.id == placeholder.id);
      if (idx >= 0) messages.removeAt(idx);
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
