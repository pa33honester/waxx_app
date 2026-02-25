// ignore_for_file: file_names

import 'dart:convert';

ChangePasswordBySellerModel changePasswordBySellerModelFromJson(String str) =>
    ChangePasswordBySellerModel.fromJson(json.decode(str));

String changePasswordBySellerModelToJson(ChangePasswordBySellerModel data) => json.encode(data.toJson());

class ChangePasswordBySellerModel {
  ChangePasswordBySellerModel({
    bool? status,
    String? message,
    Seller? seller,
  }) {
    _status = status;
    _message = message;
    _seller = seller;
  }

  ChangePasswordBySellerModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
  }

  bool? _status;
  String? _message;
  Seller? _seller;

  ChangePasswordBySellerModel copyWith({
    bool? status,
    String? message,
    Seller? seller,
  }) =>
      ChangePasswordBySellerModel(
        status: status ?? _status,
        message: message ?? _message,
        seller: seller ?? _seller,
      );

  bool? get status => _status;

  String? get message => _message;

  Seller? get seller => _seller;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    return map;
  }
}

Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));

String sellerToJson(Seller data) => json.encode(data.toJson());

class Seller {
  Seller({
    String? id,
    String? firstName,
    String? lastName,
    String? password,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _password = password;
  }

  Seller.fromJson(dynamic json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _password = json['password'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;
  String? _password;

  Seller copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? password,
  }) =>
      Seller(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        password: password ?? _password,
      );

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['password'] = _password;
    return map;
  }
}
