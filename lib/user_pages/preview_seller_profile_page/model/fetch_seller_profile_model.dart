// To parse this JSON data, do
//
//     final fetchSellerProfileModel = fetchSellerProfileModelFromJson(jsonString);

import 'dart:convert';

FetchSellerProfileModel fetchSellerProfileModelFromJson(String str) => FetchSellerProfileModel.fromJson(json.decode(str));

String fetchSellerProfileModelToJson(FetchSellerProfileModel data) => json.encode(data.toJson());

class FetchSellerProfileModel {
  bool? status;
  String? message;
  Data? data;

  FetchSellerProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchSellerProfileModel.fromJson(Map<String, dynamic> json) => FetchSellerProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;
  String? image;
  int? followers;
  int? following;
  List<ProductsByCategory>? productsByCategory;
  bool? isFollow;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
    this.image,
    this.followers,
    this.following,
    this.productsByCategory,
    this.isFollow,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        image: json["image"],
        followers: json["followers"],
        following: json["following"],
        productsByCategory: json["productsByCategory"] == null ? [] : List<ProductsByCategory>.from(json["productsByCategory"]!.map((x) => ProductsByCategory.fromJson(x))),
        isFollow: json["isFollow"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "image": image,
        "followers": followers,
        "following": following,
        "productsByCategory": productsByCategory == null ? [] : List<dynamic>.from(productsByCategory!.map((x) => x.toJson())),
        "isFollow": isFollow,
      };
}

class ProductsByCategory {
  List<Product>? products;
  String? categoryId;
  String? categoryName;

  ProductsByCategory({
    this.products,
    this.categoryId,
    this.categoryName,
  });

  factory ProductsByCategory.fromJson(Map<String, dynamic> json) => ProductsByCategory(
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}

class Product {
  String? id;
  int? price;
  bool? enableAuction;
  String? auctionEndDate;
  String? mainImage;
  String? productName;
  String? description;
  String? category;
  bool? isFavorite;

  Product({
    this.id,
    this.price,
    this.enableAuction,
    this.auctionEndDate,
    this.mainImage,
    this.productName,
    this.description,
    this.category,
    this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        price: json["price"],
        enableAuction: json["enableAuction"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        productName: json["productName"],
        description: json["description"],
        category: json["category"],
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "price": price,
        "enableAuction": enableAuction,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "productName": productName,
        "description": description,
        "category": category,
        "isFavorite": isFavorite,
      };
}
