// To parse this JSON data, do
//
//     final sellerFollowersModel = sellerFollowersModelFromJson(jsonString);

import 'dart:convert';

SellerFollowersModel sellerFollowersModelFromJson(String str) => SellerFollowersModel.fromJson(json.decode(str));

String sellerFollowersModelToJson(SellerFollowersModel data) => json.encode(data.toJson());

class SellerFollowersModel {
  bool? status;
  String? message;
  List<FollowerList>? followerList;

  SellerFollowersModel({
    this.status,
    this.message,
    this.followerList,
  });

  factory SellerFollowersModel.fromJson(Map<String, dynamic> json) => SellerFollowersModel(
        status: json["status"],
        message: json["message"],
        followerList: json["followerList"] == null ? [] : List<FollowerList>.from(json["followerList"]!.map((x) => FollowerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "followerList": followerList == null ? [] : List<dynamic>.from(followerList!.map((x) => x.toJson())),
      };
}

class FollowerList {
  String? id;
  UserId? userId;
  String? sellerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  FollowerList({
    this.id,
    this.userId,
    this.sellerId,
    this.createdAt,
    this.updatedAt,
  });

  factory FollowerList.fromJson(Map<String, dynamic> json) => FollowerList(
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        sellerId: json["sellerId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "sellerId": sellerId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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
