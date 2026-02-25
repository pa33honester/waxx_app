// To parse this JSON data, do
//
//     final userProductDetailsModel = userProductDetailsModelFromJson(jsonString);

import 'dart:convert';

UserProductDetailsModel userProductDetailsModelFromJson(String str) => UserProductDetailsModel.fromJson(json.decode(str));

String userProductDetailsModelToJson(UserProductDetailsModel data) => json.encode(data.toJson());

class UserProductDetailsModel {
  bool? status;
  String? message;
  List<Product>? product;

  UserProductDetailsModel({
    this.status,
    this.message,
    this.product,
  });

  factory UserProductDetailsModel.fromJson(Map<String, dynamic> json) => UserProductDetailsModel(
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
  String? productCode;
  bool? allowOffer;
  int? minimumOfferPrice;
  num? price;
  num? shippingCharges;
  bool? enableAuction;
  DateTime? scheduleTime;
  num? auctionStartingPrice;
  bool? enableReservePrice;
  int? reservePrice;
  int? auctionDuration;
  String? auctionEndDate;
  String? mainImage;
  List<String>? images;
  List<Attribute>? attributes;
  int? review;
  int? sold;
  bool? isOutOfStock;
  bool? isNewCollection;
  String? createStatus;
  String? updateStatus;
  String? productName;
  String? description;
  Category? category;
  Category? subCategory;
  Seller? seller;
  int? productSaleType;
  List<Rating>? rating;
  dynamic latestBidPrice;
  int? followerCount;
  bool? isFollow;
  bool? isFavorite;

  Product({
    this.id,
    this.productCode,
    this.allowOffer,
    this.minimumOfferPrice,
    this.price,
    this.shippingCharges,
    this.enableAuction,
    this.scheduleTime,
    this.auctionStartingPrice,
    this.enableReservePrice,
    this.reservePrice,
    this.auctionDuration,
    this.auctionEndDate,
    this.mainImage,
    this.images,
    this.attributes,
    this.review,
    this.sold,
    this.isOutOfStock,
    this.isNewCollection,
    this.createStatus,
    this.updateStatus,
    this.productName,
    this.description,
    this.category,
    this.subCategory,
    this.seller,
    this.productSaleType,
    this.rating,
    this.followerCount,
    this.latestBidPrice,
    this.isFollow,
    this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        productCode: json["productCode"],
        allowOffer: json["allowOffer"],
        minimumOfferPrice: json["minimumOfferPrice"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        enableAuction: json["enableAuction"],
        scheduleTime: json["scheduleTime"] == null ? null : DateTime.parse(json["scheduleTime"]),
        auctionStartingPrice: json["auctionStartingPrice"],
        enableReservePrice: json["enableReservePrice"],
        reservePrice: json["reservePrice"],
        auctionDuration: json["auctionDuration"],
        auctionEndDate: json["auctionEndDate"],
        mainImage: json["mainImage"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        review: json["review"],
        sold: json["sold"],
        isOutOfStock: json["isOutOfStock"],
        isNewCollection: json["isNewCollection"],
        createStatus: json["createStatus"],
        updateStatus: json["updateStatus"],
        productName: json["productName"],
        description: json["description"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        productSaleType: json["productSaleType"],
        rating: json["rating"] == null ? [] : List<Rating>.from(json["rating"]!.map((x) => Rating.fromJson(x))),
        followerCount: json["followerCount"],
        latestBidPrice: json["latestBidPrice"],
        isFollow: json["isFollow"],
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "allowOffer": allowOffer,
        "minimumOfferPrice": minimumOfferPrice,
        "price": price,
        "shippingCharges": shippingCharges,
        "enableAuction": enableAuction,
        "scheduleTime": scheduleTime?.toIso8601String(),
        "auctionStartingPrice": auctionStartingPrice,
        "enableReservePrice": enableReservePrice,
        "reservePrice": reservePrice,
        "auctionDuration": auctionDuration,
        "auctionEndDate": auctionEndDate,
        "mainImage": mainImage,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "review": review,
        "sold": sold,
        "isOutOfStock": isOutOfStock,
        "isNewCollection": isNewCollection,
        "createStatus": createStatus,
        "updateStatus": updateStatus,
        "productName": productName,
        "description": description,
        "category": category?.toJson(),
        "subCategory": subCategory?.toJson(),
        "seller": seller?.toJson(),
        "productSaleType": productSaleType,
        "rating": rating == null ? [] : List<dynamic>.from(rating!.map((x) => x.toJson())),
        "latestBidPrice": latestBidPrice,
        "followerCount": followerCount,
        "isFollow": isFollow,
        "isFavorite": isFavorite,
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

class Seller {
  String? id;
  Address? address;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;
  String? image;

  Seller({
    this.id,
    this.address,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
    this.image,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["_id"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "address": address?.toJson(),
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "image": image,
      };
}

class Address {
  String? city;
  String? state;
  String? country;

  Address({
    this.city,
    this.state,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        state: json["state"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "state": state,
        "country": country,
      };
}
