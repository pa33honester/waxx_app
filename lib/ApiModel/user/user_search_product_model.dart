// To parse this JSON data, do
//
//     final userSearchProductModel = userSearchProductModelFromJson(jsonString);

import 'dart:convert';

UserSearchProductModel userSearchProductModelFromJson(String str) => UserSearchProductModel.fromJson(json.decode(str));

String userSearchProductModelToJson(UserSearchProductModel data) => json.encode(data.toJson());

class UserSearchProductModel {
  bool? status;
  String? message;
  List<Product>? products;

  UserSearchProductModel({
    this.status,
    this.message,
    this.products,
  });

  factory UserSearchProductModel.fromJson(Map<String, dynamic> json) => UserSearchProductModel(
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
  String? id;
  String? productCode;
  bool? allowOffer;
  int? minimumOfferPrice;
  int? price;
  int? shippingCharges;
  bool? enableAuction;
  DateTime? scheduleTime;
  int? auctionStartingPrice;
  bool? enableReservePrice;
  int? reservePrice;
  int? auctionDuration;
  String? auctionStartDate;
  String? auctionEndDate;
  String? processingTime;
  String? recipientAddress;
  bool? isImmediatePaymentRequired;
  String? mainImage;
  List<String>? images;
  List<Attribute>? attributes;
  int? quantity;
  int? review;
  int? sold;
  int? searchCount;
  DateTime? lastSearchedAt;
  bool? isOutOfStock;
  bool? isNewCollection;
  bool? isSelect;
  bool? isAddByAdmin;
  bool? isUpdateByAdmin;
  String? createStatus;
  String? updateStatus;
  String? date;
  String? productName;
  String? description;
  Category? category;
  Category? subCategory;
  String? seller;
  int? productSaleType;
  DateTime? createdAt;
  DateTime? updatedAt;

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
    this.auctionStartDate,
    this.auctionEndDate,
    this.processingTime,
    this.recipientAddress,
    this.isImmediatePaymentRequired,
    this.mainImage,
    this.images,
    this.attributes,
    this.quantity,
    this.review,
    this.sold,
    this.searchCount,
    this.lastSearchedAt,
    this.isOutOfStock,
    this.isNewCollection,
    this.isSelect,
    this.isAddByAdmin,
    this.isUpdateByAdmin,
    this.createStatus,
    this.updateStatus,
    this.date,
    this.productName,
    this.description,
    this.category,
    this.subCategory,
    this.seller,
    this.productSaleType,
    this.createdAt,
    this.updatedAt,
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
        auctionStartDate: json["auctionStartDate"],
        auctionEndDate: json["auctionEndDate"],
        processingTime: json["processingTime"],
        recipientAddress: json["recipientAddress"],
        isImmediatePaymentRequired: json["isImmediatePaymentRequired"],
        mainImage: json["mainImage"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        quantity: json["quantity"],
        review: json["review"],
        sold: json["sold"],
        searchCount: json["searchCount"],
        lastSearchedAt: json["lastSearchedAt"] == null ? null : DateTime.parse(json["lastSearchedAt"]),
        isOutOfStock: json["isOutOfStock"],
        isNewCollection: json["isNewCollection"],
        isSelect: json["isSelect"],
        isAddByAdmin: json["isAddByAdmin"],
        isUpdateByAdmin: json["isUpdateByAdmin"],
        createStatus: json["createStatus"],
        updateStatus: json["updateStatus"],
        date: json["date"],
        productName: json["productName"],
        description: json["description"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
        seller: json["seller"],
        productSaleType: json["productSaleType"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
        "auctionStartDate": auctionStartDate,
        "auctionEndDate": auctionEndDate,
        "processingTime": processingTime,
        "recipientAddress": recipientAddress,
        "isImmediatePaymentRequired": isImmediatePaymentRequired,
        "mainImage": mainImage,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "quantity": quantity,
        "review": review,
        "sold": sold,
        "searchCount": searchCount,
        "lastSearchedAt": lastSearchedAt?.toIso8601String(),
        "isOutOfStock": isOutOfStock,
        "isNewCollection": isNewCollection,
        "isSelect": isSelect,
        "isAddByAdmin": isAddByAdmin,
        "isUpdateByAdmin": isUpdateByAdmin,
        "createStatus": createStatus,
        "updateStatus": updateStatus,
        "date": date,
        "productName": productName,
        "description": description,
        "category": category?.toJson(),
        "subCategory": subCategory?.toJson(),
        "seller": seller,
        "productSaleType": productSaleType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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
