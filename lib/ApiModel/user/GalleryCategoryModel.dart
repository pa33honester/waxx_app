// To parse this JSON data, do
//
//     final galleryCategoryModel = galleryCategoryModelFromJson(jsonString);

import 'dart:convert';

GalleryCategoryModel galleryCategoryModelFromJson(String str) => GalleryCategoryModel.fromJson(json.decode(str));

String galleryCategoryModelToJson(GalleryCategoryModel data) => json.encode(data.toJson());

class GalleryCategoryModel {
  bool? status;
  String? message;
  List<Product>? product;

  GalleryCategoryModel({
    this.status,
    this.message,
    this.product,
  });

  factory GalleryCategoryModel.fromJson(Map<String, dynamic> json) => GalleryCategoryModel(
        status: json["status"],
        message: json["message"],
        product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "product": product == null ? [] : List<dynamic>.from(product!.map((x) => x.toJson())),
      };
}

class Product {
  String? id;
  String? productName;
  String? productCode;
  String? description;
  num? price;
  num? shippingCharges;
  String? mainImage;
  List<String>? images;
  int? quantity;
  num? review;
  List<Rating>? rating;
  num? sold;
  bool? isOutOfStock;
  String? seller;
  Category? category;
  Category? subCategory;
  String? createStatus;
  String? updateStatus;
  bool? isFavorite;
  int? productSaleType;
  String? auctionEndDate;

  Product({
    this.id,
    this.productName,
    this.productCode,
    this.description,
    this.price,
    this.shippingCharges,
    this.mainImage,
    this.images,
    this.quantity,
    this.review,
    this.rating,
    this.sold,
    this.isOutOfStock,
    this.seller,
    this.category,
    this.subCategory,
    this.createStatus,
    this.updateStatus,
    this.isFavorite,
    this.productSaleType,
    this.auctionEndDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        productName: json["productName"],
        productCode: json["productCode"],
        description: json["description"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        mainImage: json["mainImage"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        quantity: json["quantity"],
        review: json["review"],
        rating: json["rating"] == null ? [] : List<Rating>.from(json["rating"]!.map((x) => Rating.fromJson(x))),
        sold: json["sold"],
        isOutOfStock: json["isOutOfStock"],
        seller: json["seller"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
        createStatus: json["createStatus"],
        updateStatus: json["updateStatus"],
        isFavorite: json["isFavorite"],
        productSaleType: json["productSaleType"],
        auctionEndDate: json["auctionEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productName": productName,
        "productCode": productCode,
        "description": description,
        "price": price,
        "shippingCharges": shippingCharges,
        "mainImage": mainImage,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "quantity": quantity,
        "review": review,
        "rating": rating == null ? [] : List<dynamic>.from(rating!.map((x) => x.toJson())),
        "sold": sold,
        "isOutOfStock": isOutOfStock,
        "seller": seller,
        "category": category?.toJson(),
        "subCategory": subCategory?.toJson(),
        "createStatus": createStatus,
        "updateStatus": updateStatus,
        "isFavorite": isFavorite,
        "productSaleType": productSaleType,
        "auctionEndDate": auctionEndDate,
      };
}

class Category {
  String? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
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
