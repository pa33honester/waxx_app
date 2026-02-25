import 'dart:convert';

SelectProductsModel SelectProductsModelFromJson(String str) =>
    SelectProductsModel.fromJson(json.decode(str));
String SelectProductsModelToJson(SelectProductsModel data) =>
    json.encode(data.toJson());

class SelectProductsModel {
  SelectProductsModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  SelectProductsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  bool? _status;
  String? _message;

  SelectProductsModel copyWith({
    bool? status,
    String? message,
  }) =>
      SelectProductsModel(
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
