// To parse this JSON data, do
//
//     final fetchCategorySubAttrModel = fetchCategorySubAttrModelFromJson(jsonString);

import 'dart:convert';

FetchCategorySubAttrModel fetchCategorySubAttrModelFromJson(String str) => FetchCategorySubAttrModel.fromJson(json.decode(str));

String fetchCategorySubAttrModelToJson(FetchCategorySubAttrModel data) => json.encode(data.toJson());

class FetchCategorySubAttrModel {
  bool? status;
  String? message;
  List<Category>? categories;
  List<SubCategory>? subCategories;
  List<FetchCategorySubAttrModelAttribute>? attributes;

  FetchCategorySubAttrModel({
    this.status,
    this.message,
    this.categories,
    this.subCategories,
    this.attributes,
  });

  factory FetchCategorySubAttrModel.fromJson(Map<String, dynamic> json) => FetchCategorySubAttrModel(
        status: json["status"],
        message: json["message"],
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        subCategories: json["subCategories"] == null ? [] : List<SubCategory>.from(json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
        attributes: json["attributes"] == null ? [] : List<FetchCategorySubAttrModelAttribute>.from(json["attributes"]!.map((x) => FetchCategorySubAttrModelAttribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "subCategories": subCategories == null ? [] : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
      };
}

class FetchCategorySubAttrModelAttribute {
  String? id;
  String? subCategory;
  List<AttributeAttribute>? attributes;

  FetchCategorySubAttrModelAttribute({
    this.id,
    this.subCategory,
    this.attributes,
  });

  factory FetchCategorySubAttrModelAttribute.fromJson(Map<String, dynamic> json) => FetchCategorySubAttrModelAttribute(
        id: json["_id"],
        subCategory: json["subCategory"],
        attributes: json["attributes"] == null ? [] : List<AttributeAttribute>.from(json["attributes"]!.map((x) => AttributeAttribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subCategory": subCategory,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
      };
}

class AttributeAttribute {
  String? name;
  String? image;
  int? fieldType;
  List<String>? values;
  int? minLength;
  int? maxLength;
  bool? isRequired;
  bool? isActive;
  String? id;

  AttributeAttribute({this.name, this.image, this.fieldType, this.values, this.minLength, this.maxLength, this.isRequired, this.isActive, this.id});

  factory AttributeAttribute.fromJson(Map<String, dynamic> json) => AttributeAttribute(
        name: json["name"],
        image: json["image"],
        fieldType: json["fieldType"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        minLength: json["minLength"],
        maxLength: json["maxLength"],
        isRequired: json["isRequired"],
        isActive: json["isActive"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "fieldType": fieldType,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "minLength": minLength,
        "maxLength": maxLength,
        "isRequired": isRequired,
        "isActive": isActive,
        "_id": id,
      };
}

class Category {
  String? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class SubCategory {
  String? id;
  String? name;
  String? category;

  SubCategory({
    this.id,
    this.name,
    this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category": category,
      };
}
