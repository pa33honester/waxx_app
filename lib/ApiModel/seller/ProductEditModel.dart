// ignore_for_file: file_names
import 'dart:convert';

ProductEditModel productEditModelFromJson(String str) => ProductEditModel.fromJson(json.decode(str));

String productEditModelToJson(ProductEditModel data) => json.encode(data.toJson());

class ProductEditModel {
  ProductEditModel({
    bool? status,
    String? message,
    UpdateProductrequest? updateProductrequest,
  }) {
    _status = status;
    _message = message;
    _updateProductrequest = updateProductrequest;
  }

  ProductEditModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _updateProductrequest =
        json['updateProductrequest'] != null ? UpdateProductrequest.fromJson(json['updateProductrequest']) : null;
  }

  bool? _status;
  String? _message;
  UpdateProductrequest? _updateProductrequest;

  ProductEditModel copyWith({
    bool? status,
    String? message,
    UpdateProductrequest? updateProductrequest,
  }) =>
      ProductEditModel(
        status: status ?? _status,
        message: message ?? _message,
        updateProductrequest: updateProductrequest ?? _updateProductrequest,
      );

  bool? get status => _status;

  String? get message => _message;

  UpdateProductrequest? get updateProductrequest => _updateProductrequest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_updateProductrequest != null) {
      map['updateProductrequest'] = _updateProductrequest?.toJson();
    }
    return map;
  }
}

UpdateProductrequest updateProductrequestFromJson(String str) => UpdateProductrequest.fromJson(json.decode(str));

String updateProductrequestToJson(UpdateProductrequest data) => json.encode(data.toJson());

class UpdateProductrequest {
  UpdateProductrequest({
    String? id,
    String? productCode,
    List<String>? images,
    int? price,
    int? shippingCharges,
    String? updateStatus,
    List<Attributes>? attributes,
    String? productName,
    String? description,
    Category? category,
    SubCategory? subCategory,
    Seller? seller,
    String? date,
    String? mainImage,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _productCode = productCode;
    _images = images;
    _price = price;
    _shippingCharges = shippingCharges;
    _updateStatus = updateStatus;
    _attributes = attributes;
    _productName = productName;
    _description = description;
    _category = category;
    _subCategory = subCategory;
    _seller = seller;
    _date = date;
    _mainImage = mainImage;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  UpdateProductrequest.fromJson(dynamic json) {
    _id = json['_id'];
    _productCode = json['productCode'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _price = json['price'];
    _shippingCharges = json['shippingCharges'];
    _updateStatus = json['updateStatus'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
    _productName = json['productName'];
    _description = json['description'];
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
    _subCategory = json['subCategory'] != null ? SubCategory.fromJson(json['subCategory']) : null;
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _date = json['date'];
    _mainImage = json['mainImage'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _productCode;
  List<String>? _images;
  int? _price;
  int? _shippingCharges;
  String? _updateStatus;
  List<Attributes>? _attributes;
  String? _productName;
  String? _description;
  Category? _category;
  SubCategory? _subCategory;
  Seller? _seller;
  String? _date;
  String? _mainImage;
  String? _createdAt;
  String? _updatedAt;

  UpdateProductrequest copyWith({
    String? id,
    String? productCode,
    List<String>? images,
    int? price,
    int? shippingCharges,
    String? updateStatus,
    List<Attributes>? attributes,
    String? productName,
    String? description,
    Category? category,
    SubCategory? subCategory,
    Seller? seller,
    String? date,
    String? mainImage,
    String? createdAt,
    String? updatedAt,
  }) =>
      UpdateProductrequest(
        id: id ?? _id,
        productCode: productCode ?? _productCode,
        images: images ?? _images,
        price: price ?? _price,
        shippingCharges: shippingCharges ?? _shippingCharges,
        updateStatus: updateStatus ?? _updateStatus,
        attributes: attributes ?? _attributes,
        productName: productName ?? _productName,
        description: description ?? _description,
        category: category ?? _category,
        subCategory: subCategory ?? _subCategory,
        seller: seller ?? _seller,
        date: date ?? _date,
        mainImage: mainImage ?? _mainImage,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get productCode => _productCode;

  List<String>? get images => _images;

  int? get price => _price;

  int? get shippingCharges => _shippingCharges;

  String? get updateStatus => _updateStatus;

  List<Attributes>? get attributes => _attributes;

  String? get productName => _productName;

  String? get description => _description;

  Category? get category => _category;

  SubCategory? get subCategory => _subCategory;

  Seller? get seller => _seller;

  String? get date => _date;

  String? get mainImage => _mainImage;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['productCode'] = _productCode;
    map['images'] = _images;
    map['price'] = _price;
    map['shippingCharges'] = _shippingCharges;
    map['updateStatus'] = _updateStatus;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    map['productName'] = _productName;
    map['description'] = _description;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    if (_subCategory != null) {
      map['subCategory'] = _subCategory?.toJson();
    }
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    map['date'] = _date;
    map['mainImage'] = _mainImage;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
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
    String? businessTag,
    String? businessName,
    String? image,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _businessTag = businessTag;
    _businessName = businessName;
    _image = image;
  }

  Seller.fromJson(dynamic json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _businessTag = json['businessTag'];
    _businessName = json['businessName'];
    _image = json['image'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;
  String? _businessTag;
  String? _businessName;
  String? _image;

  Seller copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? businessTag,
    String? businessName,
    String? image,
  }) =>
      Seller(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        businessTag: businessTag ?? _businessTag,
        businessName: businessName ?? _businessName,
        image: image ?? _image,
      );

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get businessTag => _businessTag;

  String? get businessName => _businessName;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['businessTag'] = _businessTag;
    map['businessName'] = _businessName;
    map['image'] = _image;
    return map;
  }
}

SubCategory subCategoryFromJson(String str) => SubCategory.fromJson(json.decode(str));

String subCategoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  SubCategory.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  SubCategory copyWith({
    String? id,
    String? name,
  }) =>
      SubCategory(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Category.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  Category copyWith({
    String? id,
    String? name,
  }) =>
      Category(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}

Attributes attributesFromJson(String str) => Attributes.fromJson(json.decode(str));

String attributesToJson(Attributes data) => json.encode(data.toJson());

class Attributes {
  Attributes({
    String? name,
    List<String>? value,
    String? id,
  }) {
    _name = name;
    _value = value;
    _id = id;
  }

  Attributes.fromJson(dynamic json) {
    _name = json['name'];
    _value = json['value'] != null ? json['value'].cast<String>() : [];
    _id = json['_id'];
  }

  String? _name;
  List<String>? _value;
  String? _id;

  Attributes copyWith({
    String? name,
    List<String>? value,
    String? id,
  }) =>
      Attributes(
        name: name ?? _name,
        value: value ?? _value,
        id: id ?? _id,
      );

  String? get name => _name;

  List<String>? get value => _value;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['value'] = _value;
    map['_id'] = _id;
    return map;
  }
}
