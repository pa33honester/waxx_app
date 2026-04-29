// To parse this JSON data, do
//
//     final getAllCartProductsModel = getAllCartProductsModelFromJson(jsonString);

import 'dart:convert';
import '../common/delivery_option.dart';

GetAllCartProductsModel getAllCartProductsModelFromJson(String str) => GetAllCartProductsModel.fromJson(json.decode(str));

String getAllCartProductsModelToJson(GetAllCartProductsModel data) => json.encode(data.toJson());

class GetAllCartProductsModel {
  bool? status;
  String? message;
  Data? data;

  GetAllCartProductsModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllCartProductsModel.fromJson(Map<String, dynamic> json) => GetAllCartProductsModel(
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
  num? totalItems;
  num? totalShippingCharges;
  num? subTotal;
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
  num? purchasedTimeProductPrice;
  num? purchasedTimeShippingCharges;
  // Shape B: which delivery option the buyer picked from the product's
  // `deliveryOptions[]`. Mutates via PATCH /cart/updateDeliveryOption.
  String? chosenDeliveryType;
  String? productCode;
  int? productQuantity;
  List<AttributesArray>? attributesArray;
  String? id;

  Item({
    this.productId,
    this.sellerId,
    this.purchasedTimeProductPrice,
    this.purchasedTimeShippingCharges,
    this.chosenDeliveryType,
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
        chosenDeliveryType: json["chosenDeliveryType"],
        productCode: json["productCode"],
        productQuantity: json["productQuantity"],
        attributesArray: json["attributesArray"] == null ? [] : List<AttributesArray>.from(json["attributesArray"]!.map((x) => AttributesArray.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId?.toJson(),
        "sellerId": sellerId,
        "purchasedTimeProductPrice": purchasedTimeProductPrice,
        "purchasedTimeShippingCharges": purchasedTimeShippingCharges,
        "chosenDeliveryType": chosenDeliveryType,
        "productCode": productCode,
        "productQuantity": productQuantity,
        "attributesArray": attributesArray == null ? [] : List<dynamic>.from(attributesArray!.map((x) => x.toJson())),
        "_id": id,
      };
}

class AttributesArray {
  String? name;
  List<String>? values;
  String? image;

  AttributesArray({
    this.name,
    this.values,
    this.image,
  });

  factory AttributesArray.fromJson(Map<String, dynamic> json) => AttributesArray(
        name: json["name"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "image": image,
      };
}

class ProductId {
  String? id;
  String? mainImage;
  String? productName;
  // Shape B / legacy shipping fields surfaced via the cart populate so
  // the buyer's cart UI can render the per-item picker without a second
  // round-trip to /product/detail.
  num? shippingCharges;
  String? deliveryType;
  List<DeliveryOption>? deliveryOptions;

  ProductId({
    this.id,
    this.mainImage,
    this.productName,
    this.shippingCharges,
    this.deliveryType,
    this.deliveryOptions,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        mainImage: json["mainImage"],
        productName: json["productName"],
        shippingCharges: json["shippingCharges"],
        deliveryType: json["deliveryType"],
        deliveryOptions: json["deliveryOptions"] == null
            ? []
            : List<DeliveryOption>.from(
                json["deliveryOptions"].map((x) => DeliveryOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mainImage": mainImage,
        "productName": productName,
        "shippingCharges": shippingCharges,
        "deliveryType": deliveryType,
        "deliveryOptions": deliveryOptions == null
            ? []
            : List<dynamic>.from(deliveryOptions!.map((x) => x.toJson())),
      };
}

