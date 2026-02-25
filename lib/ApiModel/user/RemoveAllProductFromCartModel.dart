// ignore_for_file: file_names
import 'dart:convert';

RemoveAllProductFromCartModel removeAllProductFromCartFromJson(String str) =>
    RemoveAllProductFromCartModel.fromJson(json.decode(str));

String removeAllProductFromCartToJson(RemoveAllProductFromCartModel data) => json.encode(data.toJson());

class RemoveAllProductFromCartModel {
  RemoveAllProductFromCartModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  RemoveAllProductFromCartModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  RemoveAllProductFromCartModel copyWith({
    bool? status,
    String? message,
  }) =>
      RemoveAllProductFromCartModel(
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
