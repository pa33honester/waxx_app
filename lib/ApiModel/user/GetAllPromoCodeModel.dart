// ignore_for_file: file_names
import 'dart:convert';

GetAllPromoCodeModel getAllPromoCodeModelFromJson(String str) => GetAllPromoCodeModel.fromJson(json.decode(str));

String getAllPromoCodeModelToJson(GetAllPromoCodeModel data) => json.encode(data.toJson());

class GetAllPromoCodeModel {
  GetAllPromoCodeModel({
    bool? status,
    String? message,
    List<PromoCode>? promoCode,
  }) {
    _status = status;
    _message = message;
    _promoCode = promoCode;
  }

  GetAllPromoCodeModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['promoCode'] != null) {
      _promoCode = [];
      json['promoCode'].forEach((v) {
        _promoCode?.add(PromoCode.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<PromoCode>? _promoCode;

  GetAllPromoCodeModel copyWith({
    bool? status,
    String? message,
    List<PromoCode>? promoCode,
  }) =>
      GetAllPromoCodeModel(
        status: status ?? _status,
        message: message ?? _message,
        promoCode: promoCode ?? _promoCode,
      );

  bool? get status => _status;

  String? get message => _message;

  List<PromoCode>? get promoCode => _promoCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_promoCode != null) {
      map['promoCode'] = _promoCode?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

PromoCode promoCodeFromJson(String str) => PromoCode.fromJson(json.decode(str));

String promoCodeToJson(PromoCode data) => json.encode(data.toJson());

class PromoCode {
  PromoCode({
    int? minOrderValue,
    String? id,
    int? discountAmount,
    List<String>? conditions,
    String? promoCode,
    int? discountType,
    String? createdAt,
    String? updatedAt,
  }) {
    _minOrderValue = minOrderValue;
    _id = id;
    _discountAmount = discountAmount;
    _conditions = conditions;
    _promoCode = promoCode;
    _discountType = discountType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  PromoCode.fromJson(dynamic json) {
    _minOrderValue = json['minOrderValue'];
    _id = json['_id'];
    _discountAmount = json['discountAmount'];
    _conditions = json['conditions'] != null ? json['conditions'].cast<String>() : [];
    _promoCode = json['promoCode'];
    _discountType = json['discountType'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  int? _minOrderValue;
  String? _id;
  int? _discountAmount;
  List<String>? _conditions;
  String? _promoCode;
  int? _discountType;
  String? _createdAt;
  String? _updatedAt;

  PromoCode copyWith({
    int? minOrderValue,
    String? id,
    int? discountAmount,
    List<String>? conditions,
    String? promoCode,
    int? discountType,
    String? createdAt,
    String? updatedAt,
  }) =>
      PromoCode(
        minOrderValue: minOrderValue ?? _minOrderValue,
        id: id ?? _id,
        discountAmount: discountAmount ?? _discountAmount,
        conditions: conditions ?? _conditions,
        promoCode: promoCode ?? _promoCode,
        discountType: discountType ?? _discountType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  int? get minOrderValue => _minOrderValue;

  String? get id => _id;

  int? get discountAmount => _discountAmount;

  List<String>? get conditions => _conditions;

  String? get promoCode => _promoCode;

  int? get discountType => _discountType;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['minOrderValue'] = _minOrderValue;
    map['_id'] = _id;
    map['discountAmount'] = _discountAmount;
    map['conditions'] = _conditions;
    map['promoCode'] = _promoCode;
    map['discountType'] = _discountType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
