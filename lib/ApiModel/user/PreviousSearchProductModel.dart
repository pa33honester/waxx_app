import 'dart:convert';

class PreviousSearchProductModel {
  bool? status;
  String? message;
  Products? products;

  PreviousSearchProductModel({
    this.status,
    this.message,
    this.products,
  });

  factory PreviousSearchProductModel.fromRawJson(String str) => PreviousSearchProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PreviousSearchProductModel.fromJson(Map<String, dynamic> json) => PreviousSearchProductModel(
        status: json["status"],
        message: json["message"],
        products: json["products"] == null ? null : Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "products": products?.toJson(),
      };
}

class Products {
  List<Product>? lastSearchedProducts;
  List<Product>? popularSearchedProducts;

  Products({
    this.lastSearchedProducts,
    this.popularSearchedProducts,
  });

  factory Products.fromRawJson(String str) => Products.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        lastSearchedProducts: json["lastSearchedProducts"] == null ? [] : List<Product>.from(json["lastSearchedProducts"]!.map((x) => Product.fromJson(x))),
        popularSearchedProducts: json["popularSearchedProducts"] == null ? [] : List<Product>.from(json["popularSearchedProducts"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastSearchedProducts": lastSearchedProducts == null ? [] : List<dynamic>.from(lastSearchedProducts!.map((x) => x.toJson())),
        "popularSearchedProducts": popularSearchedProducts == null ? [] : List<dynamic>.from(popularSearchedProducts!.map((x) => x.toJson())),
      };
}

class Product {
  String? id;
  String? productCode;
  bool? allowOffer;
  num? minimumOfferPrice;
  num? price;
  num? shippingCharges;
  bool? enableAuction;
  DateTime? scheduleTime;
  int? auctionStartingPrice;
  bool? enableReservePrice;
  num? reservePrice;
  num? auctionDuration;
  String? auctionStartDate;
  String? auctionEndDate;
  String? processingTime;
  String? recipientAddress;
  bool? isImmediatePaymentRequired;
  String? mainImage;
  List<String>? images;
  num? quantity;
  num? review;
  num? sold;
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
  String? category;
  String? subCategory;
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

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
        category: json["category"],
        subCategory: json["subCategory"],
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
        "category": category,
        "subCategory": subCategory,
        "seller": seller,
        "productSaleType": productSaleType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
