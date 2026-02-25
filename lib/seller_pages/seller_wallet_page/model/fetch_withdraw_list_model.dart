// To parse this JSON data, do
//
//     final fetchWithdrawListModel = fetchWithdrawListModelFromJson(jsonString);

import 'dart:convert';

FetchWithdrawListModel fetchWithdrawListModelFromJson(String str) => FetchWithdrawListModel.fromJson(json.decode(str));

String fetchWithdrawListModelToJson(FetchWithdrawListModel data) => json.encode(data.toJson());

class FetchWithdrawListModel {
  bool? status;
  String? message;
  List<Withdraw>? withdraw;

  FetchWithdrawListModel({
    this.status,
    this.message,
    this.withdraw,
  });

  factory FetchWithdrawListModel.fromJson(Map<String, dynamic> json) => FetchWithdrawListModel(
        status: json["status"],
        message: json["message"],
        withdraw: json["withdraw"] == null ? [] : List<Withdraw>.from(json["withdraw"]!.map((x) => Withdraw.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "withdraw": withdraw == null ? [] : List<dynamic>.from(withdraw!.map((x) => x.toJson())),
      };
}

class Withdraw {
  String? id;
  List<String>? details;
  bool? isEnabled;
  String? name;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Withdraw({
    this.id,
    this.details,
    this.isEnabled,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) => Withdraw(
        id: json["_id"],
        details: json["details"] == null ? [] : List<String>.from(json["details"]!.map((x) => x)),
        isEnabled: json["isEnabled"],
        name: json["name"],
        image: json["image"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "details": details == null ? [] : List<dynamic>.from(details!.map((x) => x)),
        "isEnabled": isEnabled,
        "name": name,
        "image": image,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
