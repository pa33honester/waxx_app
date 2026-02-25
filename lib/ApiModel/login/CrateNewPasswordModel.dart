// ignore_for_file: file_names
import 'dart:convert';

CrateNewPasswordModel crateNewPasswordModelFromJson(String str) =>
    CrateNewPasswordModel.fromJson(json.decode(str));

String crateNewPasswordModelToJson(CrateNewPasswordModel data) => json.encode(data.toJson());

class CrateNewPasswordModel {
  CrateNewPasswordModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  CrateNewPasswordModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  CrateNewPasswordModel copyWith({
    bool? status,
    String? message,
  }) =>
      CrateNewPasswordModel(
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
