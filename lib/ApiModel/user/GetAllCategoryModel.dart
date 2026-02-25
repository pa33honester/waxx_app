// ignore_for_file: file_names
import 'dart:convert';

GetAllCategoryModel getAllCategoryModelFromJson(String str) => GetAllCategoryModel.fromJson(json.decode(str));

String getAllCategoryModelToJson(GetAllCategoryModel data) => json.encode(data.toJson());

class GetAllCategoryModel {
  GetAllCategoryModel({
    bool? status,
    String? message,
    List<Category>? category,
  }) {
    _status = status;
    _message = message;
    _category = category;
  }

  GetAllCategoryModel.fromJson(dynamic json) {
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

  GetAllCategoryModel copyWith({
    bool? status,
    String? message,
    List<Category>? category,
  }) =>
      GetAllCategoryModel(
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
    String? image,
    List<SubCategory>? subCategory,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _image = image;
    _subCategory = subCategory;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Category.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    if (json['subCategory'] != null) {
      _subCategory = [];
      json['subCategory'].forEach((v) {
        _subCategory?.add(SubCategory.fromJson(v));
      });
    }
    _name = json['name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _image;
  List<SubCategory>? _subCategory;
  String? _name;
  String? _createdAt;
  String? _updatedAt;

  Category copyWith({
    String? id,
    String? image,
    List<SubCategory>? subCategory,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) =>
      Category(
        id: id ?? _id,
        image: image ?? _image,
        subCategory: subCategory ?? _subCategory,
        name: name ?? _name,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get image => _image;

  List<SubCategory>? get subCategory => _subCategory;

  String? get name => _name;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    if (_subCategory != null) {
      map['subCategory'] = _subCategory?.map((v) => v.toJson()).toList();
    }
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

SubCategory subCategoryFromJson(String str) => SubCategory.fromJson(json.decode(str));

String subCategoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    String? id,
    String? image,
    String? name,
  }) {
    _id = id;
    _image = image;
    _name = name;
  }

  SubCategory.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _name = json['name'];
  }

  String? _id;
  String? _image;
  String? _name;

  SubCategory copyWith({
    String? id,
    String? image,
    String? name,
  }) =>
      SubCategory(
        id: id ?? _id,
        image: image ?? _image,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get image => _image;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    map['name'] = _name;
    return map;
  }
}
