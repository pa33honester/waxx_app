// To parse this JSON data, do
//
//     final fetchSellerWalletHistoryModel = fetchSellerWalletHistoryModelFromJson(jsonString);

import 'dart:convert';

FetchSellerWalletHistoryModel fetchSellerWalletHistoryModelFromJson(String str) => FetchSellerWalletHistoryModel.fromJson(json.decode(str));

String fetchSellerWalletHistoryModelToJson(FetchSellerWalletHistoryModel data) => json.encode(data.toJson());

class FetchSellerWalletHistoryModel {
  bool? status;
  String? message;
  int? totalAmount;
  List<Datum>? data;

  FetchSellerWalletHistoryModel({
    this.status,
    this.message,
    this.totalAmount,
    this.data,
  });

  factory FetchSellerWalletHistoryModel.fromJson(Map<String, dynamic> json) => FetchSellerWalletHistoryModel(
        status: json["status"],
        message: json["message"],
        totalAmount: json["totalAmount"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalAmount": totalAmount,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  int? amount;
  int? transactionType;
  String? date;
  String? orderId;
  String? productName;
  String? productImage;

  Datum({
    this.id,
    this.amount,
    this.transactionType,
    this.date,
    this.orderId,
    this.productName,
    this.productImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        amount: json["amount"],
        transactionType: json["transactionType"],
        date: json["date"],
        orderId: json["orderId"],
        productName: json["productName"],
        productImage: json["productImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "amount": amount,
        "transactionType": transactionType,
        "date": date,
        "orderId": orderId,
        "productName": productName,
        "productImage": productImage,
      };
}
