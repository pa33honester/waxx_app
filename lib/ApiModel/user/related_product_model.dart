// To parse this JSON data, do
//
//     final relatedProductModel = relatedProductModelFromJson(jsonString);

import 'dart:convert';

RelatedProductModel relatedProductModelFromJson(String str) => RelatedProductModel.fromJson(json.decode(str));

String relatedProductModelToJson(RelatedProductModel data) => json.encode(data.toJson());

class RelatedProductModel {
  bool? status;
  String? message;
  List<RelatedProduct>? relatedProducts;

  RelatedProductModel({
    this.status,
    this.message,
    this.relatedProducts,
  });

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) => RelatedProductModel(
        status: json["status"],
        message: json["message"],
        relatedProducts: json["relatedProducts"] == null ? [] : List<RelatedProduct>.from(json["relatedProducts"]!.map((x) => RelatedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "relatedProducts": relatedProducts == null ? [] : List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
      };
}

class RelatedProduct {
  String? id;
  String? productName;
  String? productCode;
  String? description;
  num? price;
  num? shippingCharges;
  String? auctionEndDate;
  String? mainImage;
  List<String>? images;
  String? seller;
  bool? isFavorite;
  List<Rating>? rating;
  int? productSaleType;

  RelatedProduct({
    this.id,
    this.productName,
    this.productCode,
    this.description,
    this.price,
    this.shippingCharges,
    this.auctionEndDate,
    this.mainImage,
    this.images,
    this.seller,
    this.isFavorite,
    this.rating,
    this.productSaleType,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        id: json["_id"],
        productName: json["productName"],
        productCode: json["productCode"],
        description: json["description"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        seller: json["seller"],
        isFavorite: json["isFavorite"],
        rating: json["rating"] == null ? [] : List<Rating>.from(json["rating"]!.map((x) => Rating.fromJson(x))),
        productSaleType: json["productSaleType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productName": productName,
        "productCode": productCode,
        "description": description,
        "price": price,
        "shippingCharges": shippingCharges,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "seller": seller,
        "isFavorite": isFavorite,
        "rating": rating == null ? [] : List<dynamic>.from(rating!.map((x) => x.toJson())),
        "productSaleType": productSaleType,
      };
}

class Rating {
  String? id;
  int? totalUser;
  int? avgRating;

  Rating({
    this.id,
    this.totalUser,
    this.avgRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["_id"],
        totalUser: json["totalUser"],
        avgRating: json["avgRating"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "totalUser": totalUser,
        "avgRating": avgRating,
      };
}
