// To parse this JSON data, do
//
//     final uploadReelModel = uploadReelModelFromJson(jsonString);

import 'dart:convert';

UploadReelModel uploadReelModelFromJson(String str) => UploadReelModel.fromJson(json.decode(str));

String uploadReelModelToJson(UploadReelModel data) => json.encode(data.toJson());

class UploadReelModel {
  bool? status;
  String? message;
  Reel? reel;

  UploadReelModel({
    this.status,
    this.message,
    this.reel,
  });

  factory UploadReelModel.fromJson(Map<String, dynamic> json) => UploadReelModel(
        status: json["status"],
        message: json["message"],
        reel: json["reel"] == null ? null : Reel.fromJson(json["reel"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reel": reel?.toJson(),
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
  int? duration;
  int? like;
  bool? isFake;
  String? createdAt;
  String? updatedAt;

  Reel({
    this.id,
    this.thumbnail,
    this.video,
    this.description,
    this.videoType,
    this.thumbnailType,
    this.productId,
    this.sellerId,
    this.duration,
    this.like,
    this.isFake,
    this.createdAt,
    this.updatedAt,
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
        duration: json["duration"],
        like: json["like"],
        isFake: json["isFake"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
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
        "duration": duration,
        "like": like,
        "isFake": isFake,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class ProductId {
  String? id;
  String? productCode;
  int? price;
  int? shippingCharges;
  String? mainImage;
  List<Attribute>? attributes;
  String? createStatus;
  String? productName;
  String? seller;

  ProductId({
    this.id,
    this.productCode,
    this.price,
    this.shippingCharges,
    this.mainImage,
    this.attributes,
    this.createStatus,
    this.productName,
    this.seller,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        productCode: json["productCode"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        mainImage: json["mainImage"],
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        createStatus: json["createStatus"],
        productName: json["productName"],
        seller: json["seller"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "price": price,
        "shippingCharges": shippingCharges,
        "mainImage": mainImage,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "createStatus": createStatus,
        "productName": productName,
        "seller": seller,
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
