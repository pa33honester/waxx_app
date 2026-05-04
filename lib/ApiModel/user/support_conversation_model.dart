import 'dart:convert';

/// Wire shape returned by /support/myConversation and the realtime
/// `supportMessage` socket payload. Mirrors the SupportConversation +
/// SupportMessage subdoc shapes on the backend.
class SupportConversationModel {
  bool? status;
  String? message;
  SupportConversation? conversation;

  SupportConversationModel({this.status, this.message, this.conversation});

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) =>
      SupportConversationModel(
        status: json["status"],
        message: json["message"],
        conversation: json["conversation"] == null
            ? null
            : SupportConversation.fromJson(json["conversation"]),
      );
}

class SupportConversation {
  String? id;
  String? userId;
  String? convStatus; // "open" | "closed"
  List<SupportMessage>? messages;
  DateTime? lastActivityAt;
  int? unreadByAdmin;
  int? unreadByUser;

  SupportConversation({
    this.id,
    this.userId,
    this.convStatus,
    this.messages,
    this.lastActivityAt,
    this.unreadByAdmin,
    this.unreadByUser,
  });

  factory SupportConversation.fromJson(Map<String, dynamic> json) =>
      SupportConversation(
        id: json["_id"],
        userId: json["userId"] is Map ? json["userId"]["_id"] : json["userId"],
        convStatus: json["status"],
        messages: json["messages"] == null
            ? <SupportMessage>[]
            : List<SupportMessage>.from(
                (json["messages"] as List).map((x) => SupportMessage.fromJson(x))),
        lastActivityAt: json["lastActivityAt"] == null
            ? null
            : DateTime.tryParse(json["lastActivityAt"].toString()),
        unreadByAdmin: json["unreadByAdmin"],
        unreadByUser: json["unreadByUser"],
      );
}

class SupportMessage {
  String? id;
  String? senderType; // "user" | "admin"
  String? senderId;
  String? senderName;
  String? senderImage;
  String? text;
  bool? isRead;
  DateTime? createdAt;

  SupportMessage({
    this.id,
    this.senderType,
    this.senderId,
    this.senderName,
    this.senderImage,
    this.text,
    this.isRead,
    this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
        id: json["_id"]?.toString(),
        senderType: json["senderType"],
        senderId: json["senderId"]?.toString(),
        senderName: json["senderName"],
        senderImage: json["senderImage"],
        text: json["text"],
        isRead: json["isRead"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
      );

  /// The socket emits a JSON-encoded SupportMessage; this helper takes
  /// the raw socket payload (string OR already-decoded Map) and returns
  /// a parsed message so the controller doesn't have to repeat the
  /// boilerplate.
  static SupportMessage? tryParseSocketPayload(dynamic raw) {
    try {
      Map<String, dynamic> map;
      if (raw is String) {
        map = jsonDecode(raw) as Map<String, dynamic>;
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      } else {
        return null;
      }
      return SupportMessage.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
