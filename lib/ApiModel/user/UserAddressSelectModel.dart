// ignore_for_file: file_names
import 'dart:convert';

UserAddressSelectModel userAddressSelectModelFromJson(String str) =>
    UserAddressSelectModel.fromJson(json.decode(str));

String userAddressSelectModelToJson(UserAddressSelectModel data) => json.encode(data.toJson());

class UserAddressSelectModel {
  UserAddressSelectModel({
    bool? status,
    String? message,
    Address? address,
  }) {
    _status = status;
    _message = message;
    _address = address;
  }

  UserAddressSelectModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  bool? _status;
  String? _message;
  Address? _address;

  UserAddressSelectModel copyWith({
    bool? status,
    String? message,
    Address? address,
  }) =>
      UserAddressSelectModel(
        status: status ?? _status,
        message: message ?? _message,
        address: address ?? _address,
      );

  bool? get status => _status;

  String? get message => _message;

  Address? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    return map;
  }
}

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    String? id,
    bool? isSelect,
    UserId? userId,
    String? name,
    String? country,
    String? state,
    String? city,
    int? zipCode,
    String? address,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _isSelect = isSelect;
    _userId = userId;
    _name = name;
    _country = country;
    _state = state;
    _city = city;
    _zipCode = zipCode;
    _address = address;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Address.fromJson(dynamic json) {
    _id = json['_id'];
    _isSelect = json['isSelect'];
    _userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    _name = json['name'];
    _country = json['country'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zipCode'];
    _address = json['address'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  bool? _isSelect;
  UserId? _userId;
  String? _name;
  String? _country;
  String? _state;
  String? _city;
  int? _zipCode;
  String? _address;
  String? _createdAt;
  String? _updatedAt;

  Address copyWith({
    String? id,
    bool? isSelect,
    UserId? userId,
    String? name,
    String? country,
    String? state,
    String? city,
    int? zipCode,
    String? address,
    String? createdAt,
    String? updatedAt,
  }) =>
      Address(
        id: id ?? _id,
        isSelect: isSelect ?? _isSelect,
        userId: userId ?? _userId,
        name: name ?? _name,
        country: country ?? _country,
        state: state ?? _state,
        city: city ?? _city,
        zipCode: zipCode ?? _zipCode,
        address: address ?? _address,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  bool? get isSelect => _isSelect;

  UserId? get userId => _userId;

  String? get name => _name;

  String? get country => _country;

  String? get state => _state;

  String? get city => _city;

  int? get zipCode => _zipCode;

  String? get address => _address;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['isSelect'] = _isSelect;
    if (_userId != null) {
      map['userId'] = _userId?.toJson();
    }
    map['name'] = _name;
    map['country'] = _country;
    map['state'] = _state;
    map['city'] = _city;
    map['zipCode'] = _zipCode;
    map['address'] = _address;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

UserId userIdFromJson(String str) => UserId.fromJson(json.decode(str));

String userIdToJson(UserId data) => json.encode(data.toJson());

class UserId {
  UserId({
    String? id,
    String? firstName,
    String? lastName,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
  }

  UserId.fromJson(dynamic json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;

  UserId copyWith({
    String? id,
    String? firstName,
    String? lastName,
  }) =>
      UserId(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
      );

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    return map;
  }
}
