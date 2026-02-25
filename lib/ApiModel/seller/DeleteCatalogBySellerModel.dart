// ignore_for_file: file_names
import 'dart:convert';

DeleteCatalogBySellerModel deleteCatalogBySellerModelFromJson(String str) =>
    DeleteCatalogBySellerModel.fromJson(json.decode(str));

String deleteCatalogBySellerModelToJson(DeleteCatalogBySellerModel data) => json.encode(data.toJson());

class DeleteCatalogBySellerModel {
  DeleteCatalogBySellerModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  DeleteCatalogBySellerModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  DeleteCatalogBySellerModel copyWith({
    bool? status,
    String? message,
  }) =>
      DeleteCatalogBySellerModel(
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
