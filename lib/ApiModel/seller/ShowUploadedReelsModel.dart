// To parse this JSON data, do
//
//     final showUploadedReelsModel = showUploadedReelsModelFromJson(jsonString);

import 'dart:convert';

ShowUploadedReelsModel showUploadedReelsModelFromJson(String str) => ShowUploadedReelsModel.fromJson(json.decode(str));

String showUploadedReelsModelToJson(ShowUploadedReelsModel data) => json.encode(data.toJson());

class ShowUploadedReelsModel {
  bool? status;
  String? message;
  List<Reels>? reels;

  ShowUploadedReelsModel({
    this.status,
    this.message,
    this.reels,
  });

  factory ShowUploadedReelsModel.fromJson(Map<String, dynamic> json) => ShowUploadedReelsModel(
        status: json["status"],
        message: json["message"],
        reels: json["reels"] == null ? [] : List<Reels>.from(json["reels"]!.map((x) => Reels.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reels": reels == null ? [] : List<dynamic>.from(reels!.map((x) => x.toJson())),
      };
}

class Reels {
  String? id;
  String? video;
  String? description;
  List<ProductId>? productId;
  SellerId? sellerId;
  int? like;
  int? comment;
  bool? isFake;
  int? videoType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? duration;

  Reels({
    this.id,
    this.video,
    this.productId,
    this.description,
    this.sellerId,
    this.like,
    this.comment,
    this.isFake,
    this.videoType,
    this.createdAt,
    this.updatedAt,
    this.duration,
  });

  factory Reels.fromJson(Map<String, dynamic> json) => Reels(
        id: json["_id"],
        video: json["video"],
        description: json["description"],
        productId: json["productId"] == null ? [] : List<ProductId>.from(json["productId"]!.map((x) => ProductId.fromJson(x))),
        sellerId: json["sellerId"] == null ? null : SellerId.fromJson(json["sellerId"]),
        like: json["like"],
        comment: json["comment"],
        isFake: json["isFake"],
        videoType: json["videoType"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "video": video,
        "description": description,
        "productId": productId == null ? [] : List<dynamic>.from(productId!.map((x) => x.toJson())),
        "sellerId": sellerId?.toJson(),
        "like": like,
        "comment": comment,
        "isFake": isFake,
        "videoType": videoType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "duration": duration,
      };
}

class ProductId {
  String? id;
  String? productCode;
  int? price;
  int? shippingCharges;
  String? createStatus;
  List<Attribute>? attributes;
  String? productName;
  String? description;
  String? seller;
  String? mainImage;

  ProductId({
    this.id,
    this.productCode,
    this.price,
    this.shippingCharges,
    this.createStatus,
    this.attributes,
    this.productName,
    this.description,
    this.seller,
    this.mainImage,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        productCode: json["productCode"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        createStatus: json["createStatus"],
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        productName: json["productName"],
        description: json["description"],
        seller: json["seller"],
        mainImage: json["mainImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "price": price,
        "shippingCharges": shippingCharges,
        "createStatus": createStatus,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "productName": productName,
        "description": description,
        "seller": seller,
        "mainImage": mainImage,
      };
}

class Attribute {
  String? id;
  String? name;
  String? image;
  List<String>? values;

  Attribute({
    this.id,
    this.name,
    this.image,
    this.values,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}

class SellerId {
  String? id;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;

  SellerId({
    this.id,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
  });

  factory SellerId.fromJson(Map<String, dynamic> json) => SellerId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
      };
}
