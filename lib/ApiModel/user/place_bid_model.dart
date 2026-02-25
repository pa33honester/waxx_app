// To parse this JSON data, do
//
//     final placeBidModel = placeBidModelFromJson(jsonString);

import 'dart:convert';

PlaceBidModel placeBidModelFromJson(String str) => PlaceBidModel.fromJson(json.decode(str));

String placeBidModelToJson(PlaceBidModel data) => json.encode(data.toJson());

class PlaceBidModel {
  bool? status;
  String? message;
  Bid? bid;

  PlaceBidModel({
    this.status,
    this.message,
    this.bid,
  });

  factory PlaceBidModel.fromJson(Map<String, dynamic> json) => PlaceBidModel(
        status: json["status"],
        message: json["message"],
        bid: json["bid"] == null ? null : Bid.fromJson(json["bid"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "bid": bid?.toJson(),
      };
}

class Bid {
  String? userId;
  String? sellerId;
  String? productId;
  dynamic liveHistoryId;
  num? startingBid;
  int? currentBid;
  int? mode;
  bool? isWinningBid;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bid({
    this.userId,
    this.sellerId,
    this.productId,
    this.liveHistoryId,
    this.startingBid,
    this.currentBid,
    this.mode,
    this.isWinningBid,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        userId: json["userId"],
        sellerId: json["sellerId"],
        productId: json["productId"],
        liveHistoryId: json["liveHistoryId"],
        startingBid: json["startingBid"],
        currentBid: json["currentBid"],
        mode: json["mode"],
        isWinningBid: json["isWinningBid"],
        id: json["_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "sellerId": sellerId,
        "productId": productId,
        "liveHistoryId": liveHistoryId,
        "startingBid": startingBid,
        "currentBid": currentBid,
        "mode": mode,
        "isWinningBid": isWinningBid,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
