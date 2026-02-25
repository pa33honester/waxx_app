// To parse this JSON data, do
//
//     final productWiseUserAuctionBidModel = productWiseUserAuctionBidModelFromJson(jsonString);

import 'dart:convert';

ProductWiseUserAuctionBidModel productWiseUserAuctionBidModelFromJson(String str) => ProductWiseUserAuctionBidModel.fromJson(json.decode(str));

String productWiseUserAuctionBidModelToJson(ProductWiseUserAuctionBidModel data) => json.encode(data.toJson());

class ProductWiseUserAuctionBidModel {
  bool? status;
  String? message;
  List<Bid>? bids;

  ProductWiseUserAuctionBidModel({
    this.status,
    this.message,
    this.bids,
  });

  factory ProductWiseUserAuctionBidModel.fromJson(Map<String, dynamic> json) => ProductWiseUserAuctionBidModel(
        status: json["status"],
        message: json["message"],
        bids: json["bids"] == null ? [] : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "bids": bids == null ? [] : List<dynamic>.from(bids!.map((x) => x.toJson())),
      };
}

class Bid {
  String? id;
  UserId? userId;
  String? sellerId;
  String? productId;
  dynamic liveHistoryId;
  int? startingBid;
  int? currentBid;
  int? mode;
  bool? isWinningBid;
  String? createdAt;
  String? updatedAt;

  Bid({
    this.id,
    this.userId,
    this.sellerId,
    this.productId,
    this.liveHistoryId,
    this.startingBid,
    this.currentBid,
    this.mode,
    this.isWinningBid,
    this.createdAt,
    this.updatedAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        liveHistoryId: json["liveHistoryId"],
        startingBid: json["startingBid"],
        currentBid: json["currentBid"],
        mode: json["mode"],
        isWinningBid: json["isWinningBid"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "sellerId": sellerId,
        "productId": productId,
        "liveHistoryId": liveHistoryId,
        "startingBid": startingBid,
        "currentBid": currentBid,
        "mode": mode,
        "isWinningBid": isWinningBid,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class UserId {
  String? id;
  String? firstName;
  String? lastName;
  String? image;

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
      };
}
