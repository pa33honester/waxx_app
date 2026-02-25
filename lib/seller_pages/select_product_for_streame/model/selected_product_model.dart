import 'dart:convert';

SelectedProductModel selectedProductModelFromJson(String str) => SelectedProductModel.fromJson(json.decode(str));

String selectedProductModelToJson(SelectedProductModel data) => json.encode(data.toJson());

class SelectedProductModel {
  bool? status;
  String? message;
  Data? data;

  SelectedProductModel({
    this.status,
    this.message,
    this.data,
  });

  factory SelectedProductModel.fromJson(Map<String, dynamic> json) => SelectedProductModel(
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
  List<SelectedProduct>? selectedProducts;
  String? businessName;
  String? businessTag;
  String? image;
  String? sellerFullName;
  String? sellerUsername;

  Data({
    this.id,
    this.selectedProducts,
    this.businessName,
    this.businessTag,
    this.image,
    this.sellerFullName,
    this.sellerUsername,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        selectedProducts: json["selectedProducts"] == null ? [] : List<SelectedProduct>.from(json["selectedProducts"]!.map((x) => SelectedProduct.fromJson(x))),
        businessName: json["businessName"],
        businessTag: json["businessTag"],
        image: json["image"],
        sellerFullName: json["sellerFullName"],
        sellerUsername: json["sellerUsername"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "selectedProducts": selectedProducts == null ? [] : List<dynamic>.from(selectedProducts!.map((x) => x.toJson())),
        "businessName": businessName,
        "businessTag": businessTag,
        "image": image,
        "sellerFullName": sellerFullName,
        "sellerUsername": sellerUsername,
      };
}

class ProductAttribute {
  final String name;
  final List<String> values;
  final String? id;

  ProductAttribute({
    required this.name,
    required this.values,
    this.id,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      name: json['name'] ?? '',
      values: (json['values'] as List<dynamic>?)?.map((e) => e.toString().replaceAll('"', '')).toList() ?? [],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values,
      if (id != null) '_id': id,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'values': values,
      '_id': id,
    };
  }
}

class SelectedProduct {
  String? productId;
  String? productName;
  String? mainImage;
  num? price;
  List<ProductAttribute>? productAttributes;
  int? minimumBidPrice;
  int? minAuctionTime;
  bool? hasAuctionStarted;
  DateTime? auctionEndTime;
  String? status;
  dynamic winnerUserId;
  int? winningBid;
  String? id;

  SelectedProduct({
    this.productId,
    this.productName,
    this.mainImage,
    this.price,
    this.productAttributes,
    this.minimumBidPrice,
    this.minAuctionTime,
    this.hasAuctionStarted,
    this.auctionEndTime,
    this.status,
    this.winnerUserId,
    this.winningBid,
    this.id,
  });

  factory SelectedProduct.fromJson(Map<String, dynamic> json) => SelectedProduct(
        productId: json["productId"],
        productName: json["productName"],
        mainImage: json["mainImage"],
        price: json["price"],
        productAttributes: json["productAttributes"] == null ? [] : List<ProductAttribute>.from(json["productAttributes"]!.map((x) => ProductAttribute.fromJson(x))),
        minimumBidPrice: json["minimumBidPrice"],
        minAuctionTime: json["minAuctionTime"],
        hasAuctionStarted: json["hasAuctionStarted"],
        auctionEndTime: json["auctionEndTime"] == null ? null : DateTime.parse(json["auctionEndTime"]),
        status: json["status"],
        winnerUserId: json["winnerUserId"],
        winningBid: json["winningBid"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "mainImage": mainImage,
        "price": price,
        "productAttributes": productAttributes == null ? [] : List<dynamic>.from(productAttributes!.map((x) => x.toJson())),
        "minimumBidPrice": minimumBidPrice,
        "minAuctionTime": minAuctionTime,
        "hasAuctionStarted": hasAuctionStarted,
        "auctionEndTime": auctionEndTime?.toIso8601String(),
        "status": status,
        "winnerUserId": winnerUserId,
        "winningBid": winningBid,
        "_id": id,
      };
}
