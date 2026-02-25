// ignore_for_file: file_names
import 'dart:convert';

VerifyOtpModel verifyOtpFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  VerifyOtpModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  VerifyOtpModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  VerifyOtpModel copyWith({
    bool? status,
    String? message,
  }) =>
      VerifyOtpModel(
        status: status ?? _status,
        message: message ?? _message,
      );

  bool? get status => _status;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
