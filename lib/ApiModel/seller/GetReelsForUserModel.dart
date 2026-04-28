// To parse this JSON data, do
//
//     final getReelsForUserModel = getReelsForUserModelFromJson(jsonString);

import 'dart:convert';

GetReelsForUserModel getReelsForUserModelFromJson(String str) => GetReelsForUserModel.fromJson(json.decode(str));

String getReelsForUserModelToJson(GetReelsForUserModel data) => json.encode(data.toJson());

class GetReelsForUserModel {
  bool? status;
  String? message;
  List<Reel>? reels;

  GetReelsForUserModel({
    this.status,
    this.message,
    this.reels,
  });

  factory GetReelsForUserModel.fromJson(Map<String, dynamic> json) => GetReelsForUserModel(
        status: json["status"],
        message: json["message"],
        reels: json["reels"] == null ? [] : List<Reel>.from(json["reels"]!.map((x) => Reel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reels": reels == null ? [] : List<dynamic>.from(reels!.map((x) => x.toJson())),
      };
}

class Reel {
  String? id;
  String? thumbnail;
  String? video;
  String? description;
  int? videoType;
  int? thumbnailType;
  List<ProductId>? productId;
  SellerId? sellerId;
  int? like;
  bool? isFake;
  DateTime? createdAt;
  bool? isLike;
  bool? isFollow;
  int? duration;

  Reel({
    this.id,
    this.thumbnail,
    this.video,
    this.description,
    this.videoType,
    this.thumbnailType,
    this.productId,
    this.sellerId,
    this.like,
    this.isFake,
    this.createdAt,
    this.isLike,
    this.isFollow,
    this.duration,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
        id: json["_id"],
        thumbnail: json["thumbnail"],
        video: json["video"],
        description: json["description"],
        videoType: json["videoType"],
        thumbnailType: json["thumbnailType"],
        productId: json["productId"] == null ? [] : List<ProductId>.from(json["productId"]!.map((x) => ProductId.fromJson(x))),
        sellerId: json["sellerId"] == null ? null : SellerId.fromJson(json["sellerId"]),
        like: json["like"],
        isFake: json["isFake"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        isLike: json["isLike"],
        isFollow: json["isFollow"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "thumbnail": thumbnail,
        "video": video,
        "description": description,
        "videoType": videoType,
        "thumbnailType": thumbnailType,
        "productId": productId == null ? [] : List<dynamic>.from(productId!.map((x) => x.toJson())),
        "sellerId": sellerId?.toJson(),
        "like": like,
        "isFake": isFake,
        "createdAt": createdAt?.toIso8601String(),
        "isLike": isLike,
        "isFollow": isFollow,
        "duration": duration,
      };
}

class ProductId {
  String? id;
  String? productCode;
  int? price;
  int? shippingCharges;
  String? auctionEndDate;
  String? mainImage;
  List<Attribute>? attributes;
  String? createStatus;
  String? productName;
  String? description;
  String? seller;
  int? productSaleType;

  ProductId({
    this.id,
    this.productCode,
    this.price,
    this.shippingCharges,
    this.auctionEndDate,
    this.mainImage,
    this.attributes,
    this.createStatus,
    this.productName,
    this.description,
    this.seller,
    this.productSaleType,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        productCode: json["productCode"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        createStatus: json["createStatus"],
        productName: json["productName"],
        description: json["description"],
        seller: json["seller"],
        productSaleType: json["productSaleType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "price": price,
        "shippingCharges": shippingCharges,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "createStatus": createStatus,
        "productName": productName,
        "description": description,
        "seller": seller,
        "productSaleType": productSaleType,
      };
}

class Attribute {
  String? attributeId;
  String? name;
  String? image;
  List<String>? values;
  String? id;

  Attribute({
    this.attributeId,
    this.name,
    this.image,
    this.values,
    this.id,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        attributeId: json["id"],
        name: json["name"],
        image: json["image"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": attributeId,
        "name": name,
        "image": image,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "_id": id,
      };
}

class SellerId {
  String? id;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;
  String? image;

  SellerId({
    this.id,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
    this.image,
  });

  factory SellerId.fromJson(Map<String, dynamic> json) => SellerId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "image": image,
      };
}
