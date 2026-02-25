import 'dart:convert';

ReportReelModel reportReelModelFromJson(String str) => ReportReelModel.fromJson(json.decode(str));

String reportReelModelToJson(ReportReelModel data) => json.encode(data.toJson());

class ReportReelModel {
  bool? status;
  String? message;

  ReportReelModel({
    this.status,
    this.message,
  });

  factory ReportReelModel.fromJson(Map<String, dynamic> json) => ReportReelModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
