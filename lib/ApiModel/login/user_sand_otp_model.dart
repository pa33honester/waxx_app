import 'dart:convert';

UserSandOtpModel userSandOtpModelFromJson(String str) => UserSandOtpModel.fromJson(json.decode(str));
String userSandOtpModelToJson(UserSandOtpModel data) => json.encode(data.toJson());

class UserSandOtpModel {
  UserSandOtpModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  UserSandOtpModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  bool? _status;
  String? _message;
  UserSandOtpModel copyWith({
    bool? status,
    String? message,
  }) =>
      UserSandOtpModel(
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
