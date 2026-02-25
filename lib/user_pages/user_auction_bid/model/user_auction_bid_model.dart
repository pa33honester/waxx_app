// To parse this JSON data, do
//
//     final userAuctionBidModel = userAuctionBidModelFromJson(jsonString);

import 'dart:convert';

UserAuctionBidModel userAuctionBidModelFromJson(String str) => UserAuctionBidModel.fromJson(json.decode(str));

String userAuctionBidModelToJson(UserAuctionBidModel data) => json.encode(data.toJson());

class UserAuctionBidModel {
  bool? status;
  String? message;
  List<Product>? products;

  UserAuctionBidModel({
    this.status,
    this.message,
    this.products,
  });

  factory UserAuctionBidModel.fromJson(Map<String, dynamic> json) => UserAuctionBidModel(
        status: json["status"],
        message: json["message"],
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  List<MyBid>? myBids;
  int? myHighestBid;
  int? highestBidOnProduct;
  String? productId;
  String? productName;
  String? productCode;
  String? mainImage;
  List<Attribute>? attributes;
  String? auctionEndTime;
  String? categoryName;
  String? subCategoryName;
  Seller? seller;

  Product({
    this.myBids,
    this.myHighestBid,
    this.highestBidOnProduct,
    this.productId,
    this.productName,
    this.productCode,
    this.mainImage,
    this.attributes,
    this.auctionEndTime,
    this.categoryName,
    this.subCategoryName,
    this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        myBids: json["myBids"] == null ? [] : List<MyBid>.from(json["myBids"]!.map((x) => MyBid.fromJson(x))),
        myHighestBid: json["myHighestBid"],
        highestBidOnProduct: json["highestBidOnProduct"],
        productId: json["productId"],
        productName: json["productName"],
        productCode: json["productCode"],
        mainImage: json["mainImage"],
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        auctionEndTime: json["auctionEndTime"],
        categoryName: json["categoryName"],
        subCategoryName: json["subCategoryName"],
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      );

  Map<String, dynamic> toJson() => {
        "myBids": myBids == null ? [] : List<dynamic>.from(myBids!.map((x) => x.toJson())),
        "myHighestBid": myHighestBid,
        "highestBidOnProduct": highestBidOnProduct,
        "productId": productId,
        "productName": productName,
        "productCode": productCode,
        "mainImage": mainImage,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "auctionEndTime": auctionEndTime,
        "categoryName": categoryName,
        "subCategoryName": subCategoryName,
        "seller": seller?.toJson(),
      };
}

class Attribute {
  String? name;
  String? image;
  List<String>? values;

  Attribute({
    this.name,
    this.image,
    this.values,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: json["name"],
        image: json["image"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}

class MyBid {
  String? id;
  int? currentBid;
  int? startingBid;
  String? createdAt;

  MyBid({
    this.id,
    this.currentBid,
    this.startingBid,
    this.createdAt,
  });

  factory MyBid.fromJson(Map<String, dynamic> json) => MyBid(
        id: json["_id"],
        currentBid: json["currentBid"],
        startingBid: json["startingBid"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "currentBid": currentBid,
        "startingBid": startingBid,
        "createdAt": createdAt,
      };
}

class Seller {
  Seller();

  factory Seller.fromJson(Map<String, dynamic> json) => Seller();

  Map<String, dynamic> toJson() => {};
}
