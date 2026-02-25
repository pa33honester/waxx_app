// ignore_for_file: file_names

import 'dart:convert';

CheckUserLoginModel checkUserLoginModelFromJson(String str) => CheckUserLoginModel.fromJson(json.decode(str));

String checkUserLoginModelToJson(CheckUserLoginModel data) => json.encode(data.toJson());

class CheckUserLoginModel {
  CheckUserLoginModel({
    bool? status,
    String? message,
    bool? isLogin,
  }) {
    _status = status;
    _message = message;
    _isLogin = isLogin;
  }

  CheckUserLoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _isLogin = json['isLogin'];
  }

  bool? _status;
  String? _message;
  bool? _isLogin;

  CheckUserLoginModel copyWith({
    bool? status,
    String? message,
    bool? isLogin,
  }) =>
      CheckUserLoginModel(
        status: status ?? _status,
        message: message ?? _message,
        isLogin: isLogin ?? _isLogin,
      );

  bool? get status => _status;

  String? get message => _message;

  bool? get isLogin => _isLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['isLogin'] = _isLogin;
    return map;
  }
}
