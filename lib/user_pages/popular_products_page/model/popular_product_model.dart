// To parse this JSON data, do
//
//     final popularProductModel = popularProductModelFromJson(jsonString);

import 'dart:convert';

PopularProductModel popularProductModelFromJson(String str) => PopularProductModel.fromJson(json.decode(str));

String popularProductModelToJson(PopularProductModel data) => json.encode(data.toJson());

class PopularProductModel {
  bool? status;
  String? message;
  List<PopularProducts>? data;

  PopularProductModel({
    this.status,
    this.message,
    this.data,
  });

  factory PopularProductModel.fromJson(Map<String, dynamic> json) => PopularProductModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PopularProducts>.from(json["data"]!.map((x) => PopularProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PopularProducts {
  String? id;
  String? productCode;
  num? price;
  num? shippingCharges;
  String? auctionEndDate;
  String? mainImage;
  String? productName;
  String? description;
  int? productSaleType;
  List<Rating>? rating;
  String? categoryName;

  PopularProducts({
    this.id,
    this.productCode,
    this.price,
    this.shippingCharges,
    this.auctionEndDate,
    this.mainImage,
    this.productName,
    this.description,
    this.productSaleType,
    this.rating,
    this.categoryName,
  });

  factory PopularProducts.fromJson(Map<String, dynamic> json) => PopularProducts(
        id: json["_id"],
        productCode: json["productCode"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        productName: json["productName"],
        description: json["description"],
        productSaleType: json["productSaleType"],
        rating: json["rating"] == null ? [] : List<Rating>.from(json["rating"]!.map((x) => Rating.fromJson(x))),
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "price": price,
        "shippingCharges": shippingCharges,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "productName": productName,
        "description": description,
        "productSaleType": productSaleType,
        "rating": rating == null ? [] : List<dynamic>.from(rating!.map((x) => x.toJson())),
        "categoryName": categoryName,
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
