// ignore_for_file: file_names
import 'dart:convert';

UserAddAddressModel userAddAddressModelFromJson(String str) => UserAddAddressModel.fromJson(json.decode(str));

String userAddAddressModelToJson(UserAddAddressModel data) => json.encode(data.toJson());

class UserAddAddressModel {
  UserAddAddressModel({
    bool? status,
    String? message,
    Address? address,
  }) {
    _status = status;
    _message = message;
    _address = address;
  }

  UserAddAddressModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  bool? _status;
  String? _message;
  Address? _address;

  UserAddAddressModel copyWith({
    bool? status,
    String? message,
    Address? address,
  }) =>
      UserAddAddressModel(
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
    bool? isSelect,
    String? id,
    String? userId,
    String? name,
    String? country,
    String? state,
    String? city,
    int? zipCode,
    String? address,
    String? createdAt,
    String? updatedAt,
  }) {
    _isSelect = isSelect;
    _id = id;
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
    _isSelect = json['isSelect'];
    _id = json['_id'];
    _userId = json['userId'];
    _name = json['name'];
    _country = json['country'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zipCode'];
    _address = json['address'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  bool? _isSelect;
  String? _id;
  String? _userId;
  String? _name;
  String? _country;
  String? _state;
  String? _city;
  int? _zipCode;
  String? _address;
  String? _createdAt;
  String? _updatedAt;

  Address copyWith({
    bool? isSelect,
    String? id,
    String? userId,
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
        isSelect: isSelect ?? _isSelect,
        id: id ?? _id,
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

  bool? get isSelect => _isSelect;

  String? get id => _id;

  String? get userId => _userId;

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
    map['isSelect'] = _isSelect;
    map['_id'] = _id;
    map['userId'] = _userId;
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
