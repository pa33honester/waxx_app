class SellerChatInboxModel {
  bool? status;
  List<SellerChatInboxTile>? conversations;

  SellerChatInboxModel({this.status, this.conversations});

  factory SellerChatInboxModel.fromJson(Map<String, dynamic> json) =>
      SellerChatInboxModel(
        status: json["status"],
        conversations: json["conversations"] == null
            ? []
            : List<SellerChatInboxTile>.from(
                (json["conversations"] as List).map((x) => SellerChatInboxTile.fromJson(x))),
      );
}

class SellerChatInboxTile {
  String? id;
  SellerChatProductSnapshot? productSnapshot;
  SellerChatBuyerInfo? buyerInfo;
  String? convStatus;
  int? unreadBySeller;
  DateTime? lastActivityAt;
  SellerChatLastMessage? lastMessage;

  SellerChatInboxTile({
    this.id,
    this.productSnapshot,
    this.buyerInfo,
    this.convStatus,
    this.unreadBySeller,
    this.lastActivityAt,
    this.lastMessage,
  });

  factory SellerChatInboxTile.fromJson(Map<String, dynamic> json) => SellerChatInboxTile(
        id: json["_id"]?.toString(),
        productSnapshot: json["productSnapshot"] == null
            ? null
            : SellerChatProductSnapshot.fromJson(json["productSnapshot"]),
        buyerInfo: json["buyerId"] == null
            ? null
            : SellerChatBuyerInfo.fromJson(json["buyerId"] is Map
                ? Map<String, dynamic>.from(json["buyerId"])
                : {"_id": json["buyerId"]}),
        convStatus: json["convStatus"],
        unreadBySeller: json["unreadBySeller"],
        lastActivityAt: json["lastActivityAt"] == null
            ? null
            : DateTime.tryParse(json["lastActivityAt"].toString()),
        lastMessage: json["lastMessage"] == null
            ? null
            : SellerChatLastMessage.fromJson(json["lastMessage"]),
      );
}

class SellerChatProductSnapshot {
  String? name;
  String? image;
  double? price;

  SellerChatProductSnapshot({this.name, this.image, this.price});

  factory SellerChatProductSnapshot.fromJson(Map<String, dynamic> json) =>
      SellerChatProductSnapshot(
        name: json["name"]?.toString(),
        image: json["image"]?.toString(),
        price: (json["price"] as num?)?.toDouble(),
      );
}

class SellerChatBuyerInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? image;

  SellerChatBuyerInfo({this.id, this.firstName, this.lastName, this.image});

  String get displayName =>
      "${firstName ?? ''} ${lastName ?? ''}".trim().isNotEmpty
          ? "${firstName ?? ''} ${lastName ?? ''}".trim()
          : "Buyer";

  factory SellerChatBuyerInfo.fromJson(Map<String, dynamic> json) => SellerChatBuyerInfo(
        id: json["_id"]?.toString(),
        firstName: json["firstName"],
        lastName: json["lastName"],
        image: json["image"],
      );
}

class SellerChatLastMessage {
  String? senderType;
  String? text;
  DateTime? createdAt;

  SellerChatLastMessage({this.senderType, this.text, this.createdAt});

  factory SellerChatLastMessage.fromJson(Map<String, dynamic> json) => SellerChatLastMessage(
        senderType: json["senderType"],
        text: json["text"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
      );
}
