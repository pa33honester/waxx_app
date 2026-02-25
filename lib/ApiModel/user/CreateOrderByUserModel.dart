// To parse this JSON data, do
//
//     final createOrderByUserModel = createOrderByUserModelFromJson(jsonString);

import 'dart:convert';

CreateOrderByUserModel createOrderByUserModelFromJson(String str) => CreateOrderByUserModel.fromJson(json.decode(str));

String createOrderByUserModelToJson(CreateOrderByUserModel data) => json.encode(data.toJson());

class CreateOrderByUserModel {
  bool? status;
  String? message;
  List<Datum>? data;

  CreateOrderByUserModel({
    this.status,
    this.message,
    this.data,
  });

  factory CreateOrderByUserModel.fromJson(Map<String, dynamic> json) => CreateOrderByUserModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? orderId;
  String? userId;
  List<Item>? items;
  int? purchasedTimeadminCommissionCharges;
  int? purchasedTimeCancelOrderCharges;
  int? totalQuantity;
  int? totalItems;
  int? totalShippingCharges;
  double? discountRate;
  double? discount;
  int? subTotal;
  int? total;
  double? finalTotal;
  ShippingAddress? shippingAddress;
  PromoCode? promoCode;
  String? paymentGateway;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.orderId,
    this.userId,
    this.items,
    this.purchasedTimeadminCommissionCharges,
    this.purchasedTimeCancelOrderCharges,
    this.totalQuantity,
    this.totalItems,
    this.totalShippingCharges,
    this.discountRate,
    this.discount,
    this.subTotal,
    this.total,
    this.finalTotal,
    this.shippingAddress,
    this.promoCode,
    this.paymentGateway,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    orderId: json["orderId"],
    userId: json["userId"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    purchasedTimeadminCommissionCharges: json["purchasedTimeadminCommissionCharges"],
    purchasedTimeCancelOrderCharges: json["purchasedTimeCancelOrderCharges"],
    totalQuantity: json["totalQuantity"],
    totalItems: json["totalItems"],
    totalShippingCharges: json["totalShippingCharges"],
    discountRate: json["discountRate"]?.toDouble(),
    discount: json["discount"]?.toDouble(),
    subTotal: json["subTotal"],
    total: json["total"],
    finalTotal: json["finalTotal"]?.toDouble(),
    shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
    promoCode: json["promoCode"] == null ? null : PromoCode.fromJson(json["promoCode"]),
    paymentGateway: json["paymentGateway"],
    id: json["_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "userId": userId,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "purchasedTimeadminCommissionCharges": purchasedTimeadminCommissionCharges,
    "purchasedTimeCancelOrderCharges": purchasedTimeCancelOrderCharges,
    "totalQuantity": totalQuantity,
    "totalItems": totalItems,
    "totalShippingCharges": totalShippingCharges,
    "discountRate": discountRate,
    "discount": discount,
    "subTotal": subTotal,
    "total": total,
    "finalTotal": finalTotal,
    "shippingAddress": shippingAddress?.toJson(),
    "promoCode": promoCode?.toJson(),
    "paymentGateway": paymentGateway,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Item {
  String? productId;
  String? sellerId;
  int? purchasedTimeProductPrice;
  int? purchasedTimeShippingCharges;
  String? productCode;
  int? productQuantity;
  List<AttributesArray>? attributesArray;
  int? commissionPerProductQuantity;
  dynamic deliveredServiceName;
  dynamic trackingId;
  dynamic trackingLink;
  String? id;
  String? status;
  String? date;

  Item({
    this.productId,
    this.sellerId,
    this.purchasedTimeProductPrice,
    this.purchasedTimeShippingCharges,
    this.productCode,
    this.productQuantity,
    this.attributesArray,
    this.commissionPerProductQuantity,
    this.deliveredServiceName,
    this.trackingId,
    this.trackingLink,
    this.id,
    this.status,
    this.date,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["productId"],
    sellerId: json["sellerId"],
    purchasedTimeProductPrice: json["purchasedTimeProductPrice"],
    purchasedTimeShippingCharges: json["purchasedTimeShippingCharges"],
    productCode: json["productCode"],
    productQuantity: json["productQuantity"],
    attributesArray: json["attributesArray"] == null ? [] : List<AttributesArray>.from(json["attributesArray"]!.map((x) => AttributesArray.fromJson(x))),
    commissionPerProductQuantity: json["commissionPerProductQuantity"],
    deliveredServiceName: json["deliveredServiceName"],
    trackingId: json["trackingId"],
    trackingLink: json["trackingLink"],
    id: json["_id"],
    status: json["status"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "sellerId": sellerId,
    "purchasedTimeProductPrice": purchasedTimeProductPrice,
    "purchasedTimeShippingCharges": purchasedTimeShippingCharges,
    "productCode": productCode,
    "productQuantity": productQuantity,
    "attributesArray": attributesArray == null ? [] : List<dynamic>.from(attributesArray!.map((x) => x.toJson())),
    "commissionPerProductQuantity": commissionPerProductQuantity,
    "deliveredServiceName": deliveredServiceName,
    "trackingId": trackingId,
    "trackingLink": trackingLink,
    "_id": id,
    "status": status,
    "date": date,
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

class PromoCode {
  String? promoCode;
  int? discountType;
  int? discountAmount;
  List<String>? conditions;

  PromoCode({
    this.promoCode,
    this.discountType,
    this.discountAmount,
    this.conditions,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
    promoCode: json["promoCode"],
    discountType: json["discountType"],
    discountAmount: json["discountAmount"],
    conditions: json["conditions"] == null ? [] : List<String>.from(json["conditions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "promoCode": promoCode,
    "discountType": discountType,
    "discountAmount": discountAmount,
    "conditions": conditions == null ? [] : List<dynamic>.from(conditions!.map((x) => x)),
  };
}

class ShippingAddress {
  String? name;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? address;

  ShippingAddress({
    this.name,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.address,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    name: json["name"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zipCode"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "country": country,
    "state": state,
    "city": city,
    "zipCode": zipCode,
    "address": address,
  };
}
