// To parse this JSON data, do
//
//     final sellerReelsModel = sellerReelsModelFromJson(jsonString);

import 'dart:convert';

SellerReelsModel sellerReelsModelFromJson(String str) =>
    SellerReelsModel.fromJson(json.decode(str));

String sellerReelsModelToJson(SellerReelsModel data) =>
    json.encode(data.toJson());

class SellerReelsModel {
  final bool? status;
  final String? message;
  final List<Reel>? reels;

  SellerReelsModel({
    this.status,
    this.message,
    this.reels,
  });

  factory SellerReelsModel.fromJson(Map<String, dynamic> json) =>
      SellerReelsModel(
        status: json["status"],
        message: json["message"],
        reels: json["reels"] == null
            ? []
            : List<Reel>.from(json["reels"]!.map((x) => Reel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reels": reels == null
            ? []
            : List<dynamic>.from(reels!.map((x) => x.toJson())),
      };
}

class Reel {
  final String? description;
  final String? id;
  final String? thumbnail;
  final String? video;
  final int? videoType;
  final int? thumbnailType;
  final ProductId? productId;
  final SellerId? sellerId;
  final int? duration;
  final int? like;
  final int? comment;
  final bool? isFake;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reel({
    this.description,
    this.id,
    this.thumbnail,
    this.video,
    this.videoType,
    this.thumbnailType,
    this.productId,
    this.sellerId,
    this.duration,
    this.like,
    this.comment,
    this.isFake,
    this.createdAt,
    this.updatedAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
        description: json["description"],
        id: json["_id"],
        thumbnail: json["thumbnail"],
        video: json["video"],
        videoType: json["videoType"],
        thumbnailType: json["thumbnailType"],
        // The backend stores productId as an array (Reel.productId is
        // [{ ref: "Product" }]) so the response is always a list. Older
        // versions of this model assumed a single object, which crashed
        // the whole reels parse. Accept both shapes — pull the first
        // element when it's a list.
        productId: json["productId"] == null
            ? null
            : json["productId"] is List
                ? (json["productId"] as List).isEmpty
                    ? null
                    : ProductId.fromJson((json["productId"] as List).first as Map<String, dynamic>)
                : ProductId.fromJson(json["productId"] as Map<String, dynamic>),
        sellerId: json["sellerId"] == null
            ? null
            : SellerId.fromJson(json["sellerId"]),
        duration: json["duration"],
        like: json["like"],
        comment: json["comment"],
        isFake: json["isFake"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "_id": id,
        "thumbnail": thumbnail,
        "video": video,
        "videoType": videoType,
        "thumbnailType": thumbnailType,
        "productId": productId?.toJson(),
        "sellerId": sellerId?.toJson(),
        "duration": duration,
        "like": like,
        "comment": comment,
        "isFake": isFake,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ProductId {
  final String? id;
  final String? productCode;
  final int? price;
  final int? shippingCharges;
  final String? createStatus;
  final List<Attribute>? attributes;
  final String? productName;
  final String? description;
  final String? seller;
  final String? mainImage;

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
        attributes: json["attributes"] == null
            ? []
            : List<Attribute>.from(
                json["attributes"]!.map((x) => Attribute.fromJson(x))),
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
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "productName": productName,
        "description": description,
        "seller": seller,
        "mainImage": mainImage,
      };
}

class Attribute {
  final Name? name;
  final List<String>? value;
  final String? id;

  Attribute({
    this.name,
    this.value,
    this.id,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: nameValues.map[json["name"]]!,
        value: json["value"] == null
            ? []
            : List<String>.from(json["value"]!.map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
        "_id": id,
      };
}

enum Name { COLORS, SIZES, SLEEVE_LENGTH }

final nameValues = EnumValues({
  "Colors": Name.COLORS,
  "Sizes": Name.SIZES,
  "Sleeve Length": Name.SLEEVE_LENGTH
});

class SellerId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? businessTag;
  final String? businessName;

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
