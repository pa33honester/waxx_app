// ignore_for_file: file_names
import 'dart:convert';

AttributeAddProductModel attributeAddProductModelFromJson(String str) =>
    AttributeAddProductModel.fromJson(json.decode(str));

String attributeAddProductModelToJson(AttributeAddProductModel data) => json.encode(data.toJson());

class AttributeAddProductModel {
  AttributeAddProductModel({
    bool? status,
    String? message,
    List<Attributes>? attributes,
  }) {
    _status = status;
    _message = message;
    _attributes = attributes;
  }

  AttributeAddProductModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Attributes>? _attributes;

  AttributeAddProductModel copyWith({
    bool? status,
    String? message,
    List<Attributes>? attributes,
  }) =>
      AttributeAddProductModel(
        status: status ?? _status,
        message: message ?? _message,
        attributes: attributes ?? _attributes,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Attributes>? get attributes => _attributes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Attributes attributesFromJson(String str) => Attributes.fromJson(json.decode(str));

String attributesToJson(Attributes data) => json.encode(data.toJson());

class Attributes {
  Attributes({
    String? id,
    String? name,
    List<String>? value,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _value = value;
    _type = type;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Attributes.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _value = json['value'] != null ? json['value'].cast<String>() : [];
    _type = json['type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  List<String>? _value;
  String? _type;
  String? _createdAt;
  String? _updatedAt;

  Attributes copyWith({
    String? id,
    String? name,
    List<String>? value,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) =>
      Attributes(
        id: id ?? _id,
        name: name ?? _name,
        value: value ?? _value,
        type: type ?? _type,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get name => _name;

  List<String>? get value => _value;

  String? get type => _type;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['value'] = _value;
    map['type'] = _type;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
