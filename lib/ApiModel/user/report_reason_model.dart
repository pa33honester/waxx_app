import 'dart:convert';

ReportReasonModel reportReasonModelFromJson(String str) => ReportReasonModel.fromJson(json.decode(str));

String reportReasonModelToJson(ReportReasonModel data) => json.encode(data.toJson());

class ReportReasonModel {
  bool? status;
  String? message;
  List<Report>? data;

  ReportReasonModel({
    this.status,
    this.message,
    this.data,
  });

  factory ReportReasonModel.fromJson(Map<String, dynamic> json) => ReportReasonModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Report>.from(json["data"]!.map((x) => Report.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Report {
  String? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  Report({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["_id"],
        title: json["title"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
