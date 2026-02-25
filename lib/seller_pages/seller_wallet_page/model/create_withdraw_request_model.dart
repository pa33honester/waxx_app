// To parse this JSON data, do
//
//     final createWithdrawRequestModel = createWithdrawRequestModelFromJson(jsonString);

import 'dart:convert';

CreateWithdrawRequestModel createWithdrawRequestModelFromJson(String str) => CreateWithdrawRequestModel.fromJson(json.decode(str));

String createWithdrawRequestModelToJson(CreateWithdrawRequestModel data) => json.encode(data.toJson());

class CreateWithdrawRequestModel {
  bool? status;
  String? message;

  CreateWithdrawRequestModel({
    this.status,
    this.message,
  });

  factory CreateWithdrawRequestModel.fromJson(Map<String, dynamic> json) => CreateWithdrawRequestModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
