// To parse this JSON data, do
//
//     final showCatalogModel = showCatalogModelFromJson(jsonString);

import 'dart:convert';

ShowCatalogModel showCatalogModelFromJson(String str) => ShowCatalogModel.fromJson(json.decode(str));

String showCatalogModelToJson(ShowCatalogModel data) => json.encode(data.toJson());

class ShowCatalogModel {
  bool? status;
  String? message;
  List<Products>? products;

  ShowCatalogModel({
    this.status,
    this.message,
    this.products,
  });

  factory ShowCatalogModel.fromJson(Map<String, dynamic> json) => ShowCatalogModel(
        status: json["status"],
        message: json["message"],
        products: json["products"] == null ? [] : List<Products>.from(json["products"]!.map((x) => Products.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Products {
  String? id;
  String? productCode;
  bool? allowOffer;
  int? minimumOfferPrice;
  num? price;
  num? shippingCharges;
  bool? enableAuction;
  DateTime? scheduleTime;
  int? auctionStartingPrice;
  bool? enableReservePrice;
  int? reservePrice;
  int? auctionDuration;
  DateTime? auctionStartDate;
  DateTime? auctionEndDate;
  String? processingTime;
  String? recipientAddress;
  bool? isImmediatePaymentRequired;
  String? mainImage;
  List<String>? images;
  List<Attributes>? attributes;
  int? quantity;
  int? review;
  int? sold;
  int? searchCount;
  dynamic lastSearchedAt;
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
  Seller? seller;
  int? productSaleType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Products({
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

  factory Products.fromJson(Map<String, dynamic> json) => Products(
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
        auctionStartDate: json["auctionStartDate"] == null ? null : DateTime.parse(json["auctionStartDate"]),
        auctionEndDate: json["auctionEndDate"] == null ? null : DateTime.parse(json["auctionEndDate"]),
        processingTime: json["processingTime"],
        recipientAddress: json["recipientAddress"],
        isImmediatePaymentRequired: json["isImmediatePaymentRequired"],
        mainImage: json["mainImage"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        attributes: json["attributes"] == null ? [] : List<Attributes>.from(json["attributes"]!.map((x) => Attributes.fromJson(x))),
        quantity: json["quantity"],
        review: json["review"],
        sold: json["sold"],
        searchCount: json["searchCount"],
        lastSearchedAt: json["lastSearchedAt"],
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
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
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
        "auctionStartDate": auctionStartDate?.toIso8601String(),
        "auctionEndDate": auctionEndDate?.toIso8601String(),
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
        "lastSearchedAt": lastSearchedAt,
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
        "seller": seller?.toJson(),
        "productSaleType": productSaleType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Attributes {
  String? id;
  String? name;
  String? image;
  List<String>? values;

  Attributes({
    this.id,
    this.name,
    this.image,
    this.values,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
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

class Seller {
  String? id;
  String? firstName;
  String? lastName;
  String? businessTag;
  String? businessName;
  String? image;

  Seller({
    this.id,
    this.firstName,
    this.lastName,
    this.businessTag,
    this.businessName,
    this.image,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "image": image,
      };
}
