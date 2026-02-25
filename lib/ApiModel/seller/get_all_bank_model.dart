// To parse this JSON data, do
//
//     final getAllBankModel = getAllBankModelFromJson(jsonString);

import 'dart:convert';

GetAllBankModel getAllBankModelFromJson(String str) => GetAllBankModel.fromJson(json.decode(str));

String getAllBankModelToJson(GetAllBankModel data) => json.encode(data.toJson());

class GetAllBankModel {
  bool? status;
  String? message;
  List<Bank>? bank;

  GetAllBankModel({
    this.status,
    this.message,
    this.bank,
  });

  factory GetAllBankModel.fromJson(Map<String, dynamic> json) => GetAllBankModel(
        status: json["status"],
        message: json["message"],
        bank: json["bank"] == null ? [] : List<Bank>.from(json["bank"]!.map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "bank": bank == null ? [] : List<dynamic>.from(bank!.map((x) => x.toJson())),
      };
}

class Bank {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bank({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["_id"],
        name: json["name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
