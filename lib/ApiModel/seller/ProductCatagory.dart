// ignore_for_file: file_names
import 'dart:convert';

ProductCategory productCatagoryFromJson(String str) => ProductCategory.fromJson(json.decode(str));

String productCatagoryToJson(ProductCategory data) => json.encode(data.toJson());

class ProductCategory {
  ProductCategory({
    bool? status,
    String? message,
    List<Category>? category,
  }) {
    _status = status;
    _message = message;
    _category = category;
  }

  ProductCategory.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['category'] != null) {
      _category = [];
      json['category'].forEach((v) {
        _category?.add(Category.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Category>? _category;

  ProductCategory copyWith({
    bool? status,
    String? message,
    List<Category>? category,
  }) =>
      ProductCategory(
        status: status ?? _status,
        message: message ?? _message,
        category: category ?? _category,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Category>? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_category != null) {
      map['category'] = _category?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    String? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Category.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;

  Category copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) =>
      Category(
        id: id ?? _id,
        name: name ?? _name,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get name => _name;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
