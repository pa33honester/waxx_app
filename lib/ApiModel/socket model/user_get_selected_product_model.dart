import 'dart:convert';

UserGetSelectedProductModel userGetSelectedProductModelFromJson(String str) =>
    UserGetSelectedProductModel.fromJson(json.decode(str));

String userGetSelectedProductModelToJson(UserGetSelectedProductModel data) => json.encode(data.toJson());

class UserGetSelectedProductModel {
  UserGetSelectedProductModel({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserGetSelectedProductModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  UserGetSelectedProductModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) =>
      UserGetSelectedProductModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? id,
    List<SelectedProducts>? selectedProducts,
    String? firstName,
    String? lastName,
    String? businessName,
    String? businessTag,
    String? image,
  }) {
    _id = id;
    _selectedProducts = selectedProducts;
    _firstName = firstName;
    _lastName = lastName;
    _businessName = businessName;
    _businessTag = businessTag;
    _image = image;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    if (json['selectedProducts'] != null) {
      _selectedProducts = [];
      json['selectedProducts'].forEach((v) {
        _selectedProducts?.add(SelectedProducts.fromJson(v));
      });
    }
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _businessName = json['businessName'];
    _businessTag = json['businessTag'];
    _image = json['image'];
  }

  String? _id;
  List<SelectedProducts>? _selectedProducts;
  String? _firstName;
  String? _lastName;
  String? _businessName;
  String? _businessTag;
  String? _image;

  Data copyWith({
    String? id,
    List<SelectedProducts>? selectedProducts,
    String? firstName,
    String? lastName,
    String? businessName,
    String? businessTag,
    String? image,
  }) =>
      Data(
        id: id ?? _id,
        selectedProducts: selectedProducts ?? _selectedProducts,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        businessName: businessName ?? _businessName,
        businessTag: businessTag ?? _businessTag,
        image: image ?? _image,
      );

  String? get id => _id;

  List<SelectedProducts>? get selectedProducts => _selectedProducts;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get businessName => _businessName;

  String? get businessTag => _businessTag;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_selectedProducts != null) {
      map['selectedProducts'] = _selectedProducts?.map((v) => v.toJson()).toList();
    }
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['businessName'] = _businessName;
    map['businessTag'] = _businessTag;
    map['image'] = _image;
    return map;
  }
}

SelectedProducts selectedProductsFromJson(String str) => SelectedProducts.fromJson(json.decode(str));

String selectedProductsToJson(SelectedProducts data) => json.encode(data.toJson());

class SelectedProducts {
  SelectedProducts({
    String? id,
    int? price,
    bool? isSelect,
    List<Attributes>? attributes,
    String? productName,
    String? seller,
    String? mainImage,
  }) {
    _id = id;
    _price = price;
    _isSelect = isSelect;
    _attributes = attributes;
    _productName = productName;
    _seller = seller;
    _mainImage = mainImage;
  }

  SelectedProducts.fromJson(dynamic json) {
    _id = json['_id'];
    _price = json['price'];
    _isSelect = json['isSelect'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
    _productName = json['productName'];
    _seller = json['seller'];
    _mainImage = json['mainImage'];
  }

  String? _id;
  int? _price;
  bool? _isSelect;
  List<Attributes>? _attributes;
  String? _productName;
  String? _seller;
  String? _mainImage;

  SelectedProducts copyWith({
    String? id,
    int? price,
    bool? isSelect,
    List<Attributes>? attributes,
    String? productName,
    String? seller,
    String? mainImage,
  }) =>
      SelectedProducts(
        id: id ?? _id,
        price: price ?? _price,
        isSelect: isSelect ?? _isSelect,
        attributes: attributes ?? _attributes,
        productName: productName ?? _productName,
        seller: seller ?? _seller,
        mainImage: mainImage ?? _mainImage,
      );

  String? get id => _id;

  int? get price => _price;

  bool? get isSelect => _isSelect;

  List<Attributes>? get attributes => _attributes;

  String? get productName => _productName;

  String? get seller => _seller;

  String? get mainImage => _mainImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['price'] = _price;
    map['isSelect'] = _isSelect;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    map['productName'] = _productName;
    map['seller'] = _seller;
    map['mainImage'] = _mainImage;
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
