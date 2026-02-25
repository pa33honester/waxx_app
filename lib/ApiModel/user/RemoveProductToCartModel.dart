// To parse this JSON data, do
//
//     final removeProductToCartModel = removeProductToCartModelFromJson(jsonString);

import 'dart:convert';

RemoveProductToCartModel removeProductToCartModelFromJson(String str) => RemoveProductToCartModel.fromJson(json.decode(str));

String removeProductToCartModelToJson(RemoveProductToCartModel data) => json.encode(data.toJson());

class RemoveProductToCartModel {
  bool? status;
  String? message;
  Data? data;

  RemoveProductToCartModel({
    this.status,
    this.message,
    this.data,
  });

  factory RemoveProductToCartModel.fromJson(Map<String, dynamic> json) => RemoveProductToCartModel(
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
  int? totalItems;
  int? totalShippingCharges;
  int? subTotal;
  List<Item>? items;
  String? userId;

  Data({
    this.id,
    this.totalItems,
    this.totalShippingCharges,
    this.subTotal,
    this.items,
    this.userId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        totalItems: json["totalItems"],
        totalShippingCharges: json["totalShippingCharges"],
        subTotal: json["subTotal"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "totalItems": totalItems,
        "totalShippingCharges": totalShippingCharges,
        "subTotal": subTotal,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "userId": userId,
      };
}

class Item {
  ProductId? productId;
  String? sellerId;
  int? purchasedTimeProductPrice;
  int? purchasedTimeShippingCharges;
  String? productCode;
  int? productQuantity;
  List<AttributesArray>? attributesArray;
  String? id;

  Item({
    this.productId,
    this.sellerId,
    this.purchasedTimeProductPrice,
    this.purchasedTimeShippingCharges,
    this.productCode,
    this.productQuantity,
    this.attributesArray,
    this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"] == null ? null : ProductId.fromJson(json["productId"]),
        sellerId: json["sellerId"],
        purchasedTimeProductPrice: json["purchasedTimeProductPrice"],
        purchasedTimeShippingCharges: json["purchasedTimeShippingCharges"],
        productCode: json["productCode"],
        productQuantity: json["productQuantity"],
        attributesArray:
            json["attributesArray"] == null ? [] : List<AttributesArray>.from(json["attributesArray"]!.map((x) => AttributesArray.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId?.toJson(),
        "sellerId": sellerId,
        "purchasedTimeProductPrice": purchasedTimeProductPrice,
        "purchasedTimeShippingCharges": purchasedTimeShippingCharges,
        "productCode": productCode,
        "productQuantity": productQuantity,
        "attributesArray": attributesArray == null ? [] : List<dynamic>.from(attributesArray!.map((x) => x.toJson())),
        "_id": id,
      };
}

class AttributesArray {
  String? name;
  String? value;
  String? id;

  AttributesArray({
    this.name,
    this.value,
    this.id,
  });

  factory AttributesArray.fromJson(Map<String, dynamic> json) => AttributesArray(
        name: json["name"],
        value: json["value"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "_id": id,
      };
}

class ProductId {
  String? id;
  String? productName;
  String? mainImage;

  ProductId({
    this.id,
    this.productName,
    this.mainImage,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        productName: json["productName"],
        mainImage: json["mainImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productName": productName,
        "mainImage": mainImage,
      };
}
