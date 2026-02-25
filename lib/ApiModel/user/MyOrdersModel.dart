// To parse this JSON data, do
//
//     final myOrdersModel = myOrdersModelFromJson(jsonString);

import 'dart:convert';

MyOrdersModel myOrdersModelFromJson(String str) => MyOrdersModel.fromJson(json.decode(str));

String myOrdersModelToJson(MyOrdersModel data) => json.encode(data.toJson());

class MyOrdersModel {
  bool? status;
  String? message;
  int? totalOrders;
  List<OrderDatum>? orderData;

  MyOrdersModel({
    this.status,
    this.message,
    this.totalOrders,
    this.orderData,
  });

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) => MyOrdersModel(
        status: json["status"],
        message: json["message"],
        totalOrders: json["totalOrders"],
        orderData: json["orderData"] == null ? [] : List<OrderDatum>.from(json["orderData"]!.map((x) => OrderDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalOrders": totalOrders,
        "orderData": orderData == null ? [] : List<dynamic>.from(orderData!.map((x) => x.toJson())),
      };
}

class OrderDatum {
  String? id;
  UserId? userId;
  String? orderId;
  int? finalTotal;
  int? paymentStatus;
  String? paymentGateway;
  PromoCode? promoCode;
  ShippingAddress? shippingAddress;
  DateTime? createdAt;
  int? manualAuctionPaymentReminderDuration;
  int? liveAuctionPaymentReminderDuration;
  List<Item>? items;

  OrderDatum({
    this.id,
    this.userId,
    this.orderId,
    this.finalTotal,
    this.paymentStatus,
    this.paymentGateway,
    this.promoCode,
    this.shippingAddress,
    this.createdAt,
    this.manualAuctionPaymentReminderDuration,
    this.liveAuctionPaymentReminderDuration,
    this.items,
  });

  factory OrderDatum.fromJson(Map<String, dynamic> json) => OrderDatum(
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        orderId: json["orderId"],
        finalTotal: json["finalTotal"],
        paymentStatus: json["paymentStatus"],
        paymentGateway: json["paymentGateway"],
        promoCode: json["promoCode"] == null ? null : PromoCode.fromJson(json["promoCode"]),
        shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        manualAuctionPaymentReminderDuration: json["manualAuctionPaymentReminderDuration"],
        liveAuctionPaymentReminderDuration: json["liveAuctionPaymentReminderDuration"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "orderId": orderId,
        "finalTotal": finalTotal,
        "paymentStatus": paymentStatus,
        "paymentGateway": paymentGateway,
        "promoCode": promoCode?.toJson(),
        "shippingAddress": shippingAddress?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "manualAuctionPaymentReminderDuration": manualAuctionPaymentReminderDuration,
        "liveAuctionPaymentReminderDuration": liveAuctionPaymentReminderDuration,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
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
  double? commissionPerProductQuantity;
  int? itemDiscount;
  String? status;
  dynamic deliveredServiceName;
  dynamic trackingId;
  dynamic trackingLink;
  String? date;
  String? id;
  int? paymentTimeRemaining;

  Item({
    this.productId,
    this.sellerId,
    this.purchasedTimeProductPrice,
    this.purchasedTimeShippingCharges,
    this.productCode,
    this.productQuantity,
    this.attributesArray,
    this.commissionPerProductQuantity,
    this.itemDiscount,
    this.status,
    this.deliveredServiceName,
    this.trackingId,
    this.trackingLink,
    this.date,
    this.id,
    this.paymentTimeRemaining,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"] == null ? null : ProductId.fromJson(json["productId"]),
        sellerId: json["sellerId"],
        purchasedTimeProductPrice: json["purchasedTimeProductPrice"],
        purchasedTimeShippingCharges: json["purchasedTimeShippingCharges"],
        productCode: json["productCode"],
        productQuantity: json["productQuantity"],
        attributesArray: json["attributesArray"] == null ? [] : List<AttributesArray>.from(json["attributesArray"]!.map((x) => AttributesArray.fromJson(x))),
        commissionPerProductQuantity: json["commissionPerProductQuantity"]?.toDouble(),
        itemDiscount: json["itemDiscount"],
        status: json["status"],
        deliveredServiceName: json["deliveredServiceName"],
        trackingId: json["trackingId"],
        trackingLink: json["trackingLink"],
        date: json["date"],
        id: json["_id"],
        paymentTimeRemaining: json["_paymentTimeRemaining"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId?.toJson(),
        "sellerId": sellerId,
        "purchasedTimeProductPrice": purchasedTimeProductPrice,
        "purchasedTimeShippingCharges": purchasedTimeShippingCharges,
        "productCode": productCode,
        "productQuantity": productQuantity,
        "attributesArray": attributesArray == null ? [] : List<dynamic>.from(attributesArray!.map((x) => x.toJson())),
        "commissionPerProductQuantity": commissionPerProductQuantity,
        "itemDiscount": itemDiscount,
        "status": status,
        "deliveredServiceName": deliveredServiceName,
        "trackingId": trackingId,
        "trackingLink": trackingLink,
        "date": date,
        "_id": id,
        "_paymentTimeRemaining": paymentTimeRemaining,
      };
}

class AttributesArray {
  String? name;
  List<String>? values;
  String? id;

  AttributesArray({
    this.name,
    this.values,
    this.id,
  });

  factory AttributesArray.fromJson(Map<String, dynamic> json) => AttributesArray(
        name: json["name"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
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

class PromoCode {
  dynamic promoCode;
  dynamic discountType;
  dynamic discountAmount;
  List<dynamic>? conditions;

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
        conditions: json["conditions"] == null ? [] : List<dynamic>.from(json["conditions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "promoCode": promoCode,
        "discountType": discountType,
        "discountAmount": discountAmount,
        "conditions": conditions == null ? [] : List<dynamic>.from(conditions!.map((x) => x)),
      };
}

class ShippingAddress {
  dynamic name;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zipCode;
  dynamic address;

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

class UserId {
  String? id;
  String? firstName;
  String? lastName;
  dynamic mobileNumber;

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
      };
}
