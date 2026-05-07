import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/user/support_conversation_model.dart';
import 'package:waxxapp/ApiService/user/support_chat_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';

/// State for the buyer-side customer-support chat view. Owns:
///   * the message list (reactive, `messages.obs`)
///   * the text input controller
///   * the conversation id used to scope socket joins
///   * a Worker that watches `SocketServices.supportMessageStream` and
///     appends incoming messages without dropping any (de-duped by id
///     against the user's own optimistic appends).
///
/// On `onInit` the controller fetches (or lazily creates) the user's
/// conversation, then emits `supportJoin` so subsequent admin replies
/// stream in via the `supportMessage` socket event. On `onClose` it
/// emits `supportLeave` and cancels the worker so we don't leak
/// listeners.
class SupportChatController extends GetxController {
  final RxList<SupportMessage> messages = <SupportMessage>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSending = false.obs;
  // Presence indicator — flips true while an admin has the buyer's
  // conversation open in the React panel. The view uses this to render
  // a "Support is online" banner above the message list so the buyer
  // knows their messages are being seen in real time.
  final RxBool adminPresent = false.obs;
  final RxString adminName = "Support".obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String? _conversationId;
  Worker? _socketWorker;
  Worker? _presenceWorker;
  Worker? _readWorker;

  String? get conversationId => _conversationId;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
    // Subscribe to the socket message stream. The listener is a
    // closure capturing `this`, but the GetxController lifecycle calls
    // onClose where we dispose the Worker — clean up is automatic.
    _socketWorker = ever<dynamic>(SocketServices.supportMessageStream, _onSocketMessage);
    _presenceWorker = ever<dynamic>(SocketServices.supportPresenceStream, _onPresence);
    _readWorker = ever<dynamic>(SocketServices.supportReadStream, _onRead);
  }

  @override
  void onClose() {
    _socketWorker?.dispose();
    _presenceWorker?.dispose();
    _readWorker?.dispose();
    if (_conversationId != null && _conversationId!.isNotEmpty) {
      SocketServices.onSupportLeave(conversationId: _conversationId!);
    }
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Backend broadcasts supportRead with `{conversationId, readerSide}`
  // when an admin opens the conversation in the support panel. We
  // flip ALL user-sent messages currently in the list to isRead=true,
  // which the bubble UI uses to render the double-tick (read) state.
  void _onRead(dynamic raw) {
    if (raw == null) return;
    try {
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      // Defensive — only act on this conversation's reads.
      if (_conversationId != null &&
          (map["conversationId"]?.toString() ?? "") != _conversationId) {
        return;
      }
      // The buyer's chat only cares when the ADMIN reads — that's the
      // signal for "your support message has been seen."
      if (map["readerSide"] != "admin") return;
      var changed = false;
      for (var i = 0; i < messages.length; i++) {
        final m = messages[i];
        if (m.senderType == "user" && m.isRead != true) {
          messages[i] = SupportMessage(
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

  void _onPresence(dynamic raw) {
    if (raw == null) return;
    try {
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      // Ignore presence pings for OTHER conversations (a buyer should
      // only have one anyway, but defend just in case the global stream
      // ever multiplexes).
      if (_conversationId != null &&
          (map["conversationId"]?.toString() ?? "") != _conversationId) {
        return;
      }
      adminPresent.value = map["adminPresent"] == true;
      final n = (map["name"] ?? "").toString().trim();
      if (n.isNotEmpty) adminName.value = n;
    } catch (_) {}
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    try {
      final conv = await SupportChatService.fetchMyConversation(
        userId: Database.loginUserId,
      );
      if (conv == null) {
        // Network or auth failure — leave the message list empty and
        // let the user retry by tapping the refresh action. The view
        // surfaces this via isLoading=false + empty state.
        return;
      }
      _conversationId = conv.id;
      messages.assignAll(conv.messages ?? const <SupportMessage>[]);
      if (_conversationId != null && _conversationId!.isNotEmpty) {
        SocketServices.onSupportJoin(conversationId: _conversationId!);
      }
      // Defer the scroll-to-bottom one frame so the ListView has been
      // built with the seeded messages before we measure its extent.
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      log("SupportChatController bootstrap error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _onSocketMessage(dynamic raw) {
    if (raw == null) return;
    final msg = SupportMessage.tryParseSocketPayload(raw);
    if (msg == null) return;
    // De-dupe: an admin-sent message arrives only via socket, but a
    // user-sent message can come back via socket AFTER the optimistic
    // local append. Drop dupes by message id.
    if (msg.id != null && messages.any((m) => m.id == msg.id)) return;
    messages.add(msg);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isSending.value) return;
    isSending.value = true;

    // Optimistic append so the user sees their message immediately. We
    // use a placeholder id; the socket echo from the backend will carry
    // the real persisted id. The de-dupe in _onSocketMessage skips the
    // echo iff the placeholder id matches — but it won't, so the echo
    // is appended too. To prevent that, we replace the placeholder
    // entry with the persisted one when the HTTP response returns.
    final placeholder = SupportMessage(
      id: "local_${DateTime.now().millisecondsSinceEpoch}",
      senderType: "user",
      senderName: "You",
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );
    messages.add(placeholder);
    inputController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final persisted = await SupportChatService.sendMessage(
        userId: Database.loginUserId,
        text: text,
      );
      // Replace placeholder with the real persisted record so the
      // socket echo (which carries the same _id) gets de-duped by
      // _onSocketMessage cleanly.
      final idx = messages.indexWhere((m) => m.id == placeholder.id);
      if (persisted != null && idx >= 0) {
        messages[idx] = persisted;
      } else if (persisted == null) {
        // Send failed — remove the placeholder so the user can retry.
        // (Alternatively we could keep it with an error icon; v1 keeps
        // it simple.)
        if (idx >= 0) messages.removeAt(idx);
      }
    } catch (e) {
      log("SupportChatController.sendMessage error: $e");
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
