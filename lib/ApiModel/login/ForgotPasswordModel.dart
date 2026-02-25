// ignore_for_file: file_names
import 'dart:convert';

ForgotPasswordModel forgotPasswordFromJson(String str) => ForgotPasswordModel.fromJson(json.decode(str));

String forgotPasswordToJson(ForgotPasswordModel data) => json.encode(data.toJson());

class ForgotPasswordModel {
  ForgotPasswordModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  ForgotPasswordModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  ForgotPasswordModel copyWith({
    bool? status,
    String? message,
  }) =>
      ForgotPasswordModel(
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
