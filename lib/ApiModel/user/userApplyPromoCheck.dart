// ignore_for_file: file_names
import 'dart:convert';

UserApplyPromoCheckModel userApplyPromoCheckFromJson(String str) =>
    UserApplyPromoCheckModel.fromJson(json.decode(str));

String userApplyPromoCheckToJson(UserApplyPromoCheckModel data) => json.encode(data.toJson());

class UserApplyPromoCheckModel {
  UserApplyPromoCheckModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  UserApplyPromoCheckModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  UserApplyPromoCheckModel copyWith({
    bool? status,
    String? message,
  }) =>
      UserApplyPromoCheckModel(
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
