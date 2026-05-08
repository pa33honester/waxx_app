// ignore_for_file: file_names
import 'dart:convert';

SelfieVerificationModel selfieVerificationModelFromJson(String str) =>
    SelfieVerificationModel.fromJson(json.decode(str));

String selfieVerificationModelToJson(SelfieVerificationModel data) =>
    json.encode(data.toJson());

class SelfieVerificationModel {
  bool? status;
  String? message;
  VerificationData? verification;

  SelfieVerificationModel({this.status, this.message, this.verification});

  SelfieVerificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    verification = json['verification'] != null
        ? VerificationData.fromJson(json['verification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (verification != null) map['verification'] = verification!.toJson();
    return map;
  }
}

class VerificationData {
  String? id;
  String? userId;
  String? selfieFile;
  String? status; // "pending_review" | "verified" | "rejected"
  String? rejectionReason;
  String? reviewedAt;
  String? createdAt;

  VerificationData({
    this.id,
    this.userId,
    this.selfieFile,
    this.status,
    this.rejectionReason,
    this.reviewedAt,
    this.createdAt,
  });

  VerificationData.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    userId = json['userId']?.toString();
    selfieFile = json['selfieFile'];
    status = json['status'];
    rejectionReason = json['rejectionReason'];
    reviewedAt = json['reviewedAt']?.toString();
    createdAt = json['createdAt']?.toString();
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'selfieFile': selfieFile,
        'status': status,
        'rejectionReason': rejectionReason,
        'reviewedAt': reviewedAt,
        'createdAt': createdAt,
      };
}
