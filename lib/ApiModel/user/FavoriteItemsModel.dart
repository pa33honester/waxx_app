// To parse this JSON data, do
//
//     final favoriteItemsModel = favoriteItemsModelFromJson(jsonString);

import 'dart:convert';

FavoriteItemsModel favoriteItemsModelFromJson(String str) => FavoriteItemsModel.fromJson(json.decode(str));

String favoriteItemsModelToJson(FavoriteItemsModel data) => json.encode(data.toJson());

class FavoriteItemsModel {
  bool? status;
  String? message;
  List<Favorite>? favorite;

  FavoriteItemsModel({
    this.status,
    this.message,
    this.favorite,
  });

  factory FavoriteItemsModel.fromJson(Map<String, dynamic> json) => FavoriteItemsModel(
        status: json["status"],
        message: json["message"],
        favorite: json["favorite"] == null ? [] : List<Favorite>.from(json["favorite"]!.map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "favorite": favorite == null ? [] : List<dynamic>.from(favorite!.map((x) => x.toJson())),
      };
}

class Favorite {
  String? id;
  String? userId;
  String? productId;
  String? categoryId;
  List<Product>? product;

  Favorite({
    this.id,
    this.userId,
    this.productId,
    this.categoryId,
    this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["_id"],
        userId: json["userId"],
        productId: json["productId"],
        categoryId: json["categoryId"],
        product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "productId": productId,
        "categoryId": categoryId,
        "product": product == null ? [] : List<dynamic>.from(product!.map((x) => x.toJson())),
      };
}

class Product {
  String? id;
  int? price;
  bool? enableAuction;
  String? auctionEndDate;
  String? mainImage;
  String? productName;
  int? productSaleType;
  String? category;
  String? subCategory;

  Product({
    this.id,
    this.price,
    this.enableAuction,
    this.auctionEndDate,
    this.mainImage,
    this.productName,
    this.productSaleType,
    this.category,
    this.subCategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        price: json["price"],
        enableAuction: json["enableAuction"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        productName: json["productName"],
        productSaleType: json["productSaleType"],
        category: json["category"],
        subCategory: json["subCategory"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "price": price,
        "enableAuction": enableAuction,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "productName": productName,
        "productSaleType": productSaleType,
        "category": category,
        "subCategory": subCategory,
      };
}
