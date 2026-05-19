import 'dart:convert';

class ProductChatConversationModel {
  bool? status;
  String? message;
  ProductChatConversation? conversation;

  ProductChatConversationModel({this.status, this.message, this.conversation});

  factory ProductChatConversationModel.fromJson(Map<String, dynamic> json) =>
      ProductChatConversationModel(
        status: json["status"],
        message: json["message"],
        conversation: json["conversation"] == null
            ? null
            : ProductChatConversation.fromJson(json["conversation"]),
      );
}

class ProductChatConversation {
  String? id;
  String? productId;
  String? buyerId;
  String? sellerId;
  ProductChatSnapshot? productSnapshot;
  String? convStatus;
  List<ProductChatMessage>? messages;
  int? unreadByBuyer;
  int? unreadBySeller;
  DateTime? lastActivityAt;

  ProductChatConversation({
    this.id,
    this.productId,
    this.buyerId,
    this.sellerId,
    this.productSnapshot,
    this.convStatus,
    this.messages,
    this.unreadByBuyer,
    this.unreadBySeller,
    this.lastActivityAt,
  });

  factory ProductChatConversation.fromJson(Map<String, dynamic> json) =>
      ProductChatConversation(
        id: json["_id"]?.toString(),
        productId: json["productId"]?.toString(),
        buyerId: json["buyerId"] is Map ? json["buyerId"]["_id"] : json["buyerId"]?.toString(),
        sellerId: json["sellerId"] is Map ? json["sellerId"]["_id"] : json["sellerId"]?.toString(),
        productSnapshot: json["productSnapshot"] == null
            ? null
            : ProductChatSnapshot.fromJson(json["productSnapshot"]),
        convStatus: json["status"],
        messages: json["messages"] == null
            ? <ProductChatMessage>[]
            : List<ProductChatMessage>.from(
                (json["messages"] as List).map((x) => ProductChatMessage.fromJson(x))),
        unreadByBuyer: json["unreadByBuyer"],
        unreadBySeller: json["unreadBySeller"],
        lastActivityAt: json["lastActivityAt"] == null
            ? null
            : DateTime.tryParse(json["lastActivityAt"].toString()),
      );
}

class ProductChatSnapshot {
  String? name;
  String? image;
  double? price;

  ProductChatSnapshot({this.name, this.image, this.price});

  factory ProductChatSnapshot.fromJson(Map<String, dynamic> json) => ProductChatSnapshot(
        name: json["name"]?.toString(),
        image: json["image"]?.toString(),
        price: (json["price"] as num?)?.toDouble(),
      );
}

class ProductChatMessage {
  String? id;
  String? senderType; // "buyer" | "seller"
  String? senderId;
  String? senderName;
  String? senderImage;
  String? text;
  bool? isRead;
  DateTime? createdAt;

  ProductChatMessage({
    this.id,
    this.senderType,
    this.senderId,
    this.senderName,
    this.senderImage,
    this.text,
    this.isRead,
    this.createdAt,
  });

  factory ProductChatMessage.fromJson(Map<String, dynamic> json) => ProductChatMessage(
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

  static ProductChatMessage? tryParseSocketPayload(dynamic raw) {
    try {
      Map<String, dynamic> map;
      if (raw is String) {
        map = jsonDecode(raw) as Map<String, dynamic>;
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      } else {
        return null;
      }
      return ProductChatMessage.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
