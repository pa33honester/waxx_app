import 'dart:convert';

CheckPasswordModel checkPasswordModelFromJson(String str) => CheckPasswordModel.fromJson(json.decode(str));

String checkPasswordModelToJson(CheckPasswordModel data) => json.encode(data.toJson());

class CheckPasswordModel {
  CheckPasswordModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  CheckPasswordModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  CheckPasswordModel copyWith({
    bool? status,
    String? message,
  }) =>
      CheckPasswordModel(
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
