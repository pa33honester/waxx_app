// To parse this JSON data, do
//
//     final fetchSellerWithdrawHistory = fetchSellerWithdrawHistoryFromJson(jsonString);

import 'dart:convert';

FetchSellerWithdrawHistory fetchSellerWithdrawHistoryFromJson(String str) =>
    FetchSellerWithdrawHistory.fromJson(json.decode(str));

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
  int? payoutStatus;
  String? reason;
  int? type;
  int? amount;
  String? uniqueId;
  String? date;
  DateTime? createdAt;

  Datum({
    this.id,
    this.payoutStatus,
    this.reason,
    this.type,
    this.amount,
    this.uniqueId,
    this.date,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        payoutStatus: json["payoutStatus"],
        reason: json["reason"],
        type: json["type"],
        amount: json["amount"],
        uniqueId: json["uniqueId"],
        date: json["date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "payoutStatus": payoutStatus,
        "reason": reason,
        "type": type,
        "amount": amount,
        "uniqueId": uniqueId,
        "date": date,
        "createdAt": createdAt?.toIso8601String(),
      };
}
