// To parse this JSON data, do
//
//     final sellerLiveStreamListModel = sellerLiveStreamListModelFromJson(jsonString);

import 'dart:convert';

import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';

SellerLiveStreamListModel sellerLiveStreamListModelFromJson(String str) => SellerLiveStreamListModel.fromJson(json.decode(str));

String sellerLiveStreamListModelToJson(SellerLiveStreamListModel data) => json.encode(data.toJson());

class SellerLiveStreamListModel {
  bool? status;
  String? message;
  int? total;
  List<LiveSeller>? liveSeller;

  SellerLiveStreamListModel({
    this.status,
    this.message,
    this.total,
    this.liveSeller,
  });

  factory SellerLiveStreamListModel.fromJson(Map<String, dynamic> json) => SellerLiveStreamListModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        liveSeller: json["liveSeller"] == null ? [] : List<LiveSeller>.from(json["liveSeller"]!.map((x) => LiveSeller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "liveSeller": liveSeller == null ? [] : List<dynamic>.from(liveSeller!.map((x) => x.toJson())),
      };
}

class LiveSeller {
  String? id;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;
  String? email;
  String? mobileNumber;
  String? image;
  bool? isLive;
  bool? isFake;
  dynamic video;
  List<SelectedProduct>? selectedProducts;
  String? liveSellingHistoryId;
  int? view;
  int? liveType;
  int? currentHighestBid;
  CurrentHighestBidder? currentHighestBidder;
  int? totalRemainingTime;
  String? sellerId;

  LiveSeller({
    this.id,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
    this.email,
    this.mobileNumber,
    this.image,
    this.isLive,
    this.isFake,
    this.video,
    this.selectedProducts,
    this.liveSellingHistoryId,
    this.view,
    this.sellerId,
    this.currentHighestBid,
    this.currentHighestBidder,
    this.totalRemainingTime,
    this.liveType,
  });

  factory LiveSeller.fromJson(Map<String, dynamic> json) => LiveSeller(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        image: json["image"],
        isLive: json["isLive"],
        isFake: json["isFake"],
        video: json["video"],
        selectedProducts: json["selectedProducts"] == null ? [] : List<SelectedProduct>.from(json["selectedProducts"]!.map((x) => SelectedProduct.fromJson(x))),
        liveSellingHistoryId: json["liveSellingHistoryId"],
        view: json["view"],
        sellerId: json["sellerId"],
        currentHighestBid: json["currentHighestBid"],
        currentHighestBidder: json["currentHighestBidder"] == null ? null : CurrentHighestBidder.fromJson(json["currentHighestBidder"]),
        totalRemainingTime: json["totalRemainingTime"],
        liveType: json["liveType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "email": email,
        "mobileNumber": mobileNumber,
        "image": image,
        "isLive": isLive,
        "isFake": isFake,
        "video": video,
        "selectedProducts": selectedProducts == null ? [] : List<dynamic>.from(selectedProducts!.map((x) => x.toJson())),
        "liveSellingHistoryId": liveSellingHistoryId,
        "view": view,
        "sellerId": sellerId,
        "currentHighestBid": currentHighestBid,
        "currentHighestBidder": currentHighestBidder?.toJson(),
        "totalRemainingTime": totalRemainingTime,
        "liveType": liveType
      };
}

class CurrentHighestBidder {
  String? id;
  String? name;
  String? userName;
  String? image;
  bool? isProfileImageBanned;

  CurrentHighestBidder({
    this.id,
    this.name,
    this.userName,
    this.image,
    this.isProfileImageBanned,
  });

  factory CurrentHighestBidder.fromJson(Map<String, dynamic> json) => CurrentHighestBidder(
        id: json["_id"],
        name: json["name"],
        userName: json["userName"],
        image: json["image"],
        isProfileImageBanned: json["isProfileImageBanned"],
      );

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "userName": userName, "image": image, "isProfileImageBanned": isProfileImageBanned};
}
