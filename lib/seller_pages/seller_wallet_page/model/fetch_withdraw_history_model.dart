// To parse this JSON data, do
//
//     final fetchSellerWithdrawHistory = fetchSellerWithdrawHistoryFromJson(jsonString);

import 'dart:convert';

FetchSellerWithdrawHistory fetchSellerWithdrawHistoryFromJson(String str) => FetchSellerWithdrawHistory.fromJson(json.decode(str));

String fetchSellerWithdrawHistoryToJson(FetchSellerWithdrawHistory data) => json.encode(data.toJson());

class FetchSellerWithdrawHistory {
  bool? status;
  String? message;
  List<Datum>? data;

  FetchSellerWithdrawHistory({
    this.status,
    this.message,
    this.data,
  });

  factory FetchSellerWithdrawHistory.fromJson(Map<String, dynamic> json) => FetchSellerWithdrawHistory(
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
  String? id;
  String? sellerId;
  int? amount;
  int? coin;
  int? status;
  String? paymentGateway;
  List<String>? paymentDetails;
  String? reason;
  String? uniqueId;
  String? requestDate;
  String? acceptOrDeclineDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.sellerId,
    this.amount,
    this.coin,
    this.status,
    this.paymentGateway,
    this.paymentDetails,
    this.reason,
    this.uniqueId,
    this.requestDate,
    this.acceptOrDeclineDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        sellerId: json["sellerId"],
        amount: json["amount"],
        coin: json["coin"],
        status: json["status"],
        paymentGateway: json["paymentGateway"],
        paymentDetails: json["paymentDetails"] == null ? [] : List<String>.from(json["paymentDetails"]!.map((x) => x)),
        reason: json["reason"],
        uniqueId: json["uniqueId"],
        requestDate: json["requestDate"],
        acceptOrDeclineDate: json["acceptOrDeclineDate"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sellerId": sellerId,
        "amount": amount,
        "coin": coin,
        "status": status,
        "paymentGateway": paymentGateway,
        "paymentDetails": paymentDetails == null ? [] : List<dynamic>.from(paymentDetails!.map((x) => x)),
        "reason": reason,
        "uniqueId": uniqueId,
        "requestDate": requestDate,
        "acceptOrDeclineDate": acceptOrDeclineDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
