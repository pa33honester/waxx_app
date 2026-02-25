// ignore_for_file: file_names
import 'dart:convert';

AddProductModel addProductModelFromJson(String str) => AddProductModel.fromJson(json.decode(str));

String addProductModelToJson(AddProductModel data) => json.encode(data.toJson());

class AddProductModel {
  AddProductModel({
    bool? status,
    String? message,
    Product? product,
  }) {
    _status = status;
    _message = message;
    _product = product;
  }

  AddProductModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  bool? _status;
  String? _message;
  Product? _product;

  AddProductModel copyWith({
    bool? status,
    String? message,
    Product? product,
  }) =>
      AddProductModel(
        status: status ?? _status,
        message: message ?? _message,
        product: product ?? _product,
      );

  bool? get status => _status;

  String? get message => _message;

  Product? get product => _product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    return map;
  }
}

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    String? id,
    String? productCode,
    int? price,
    int? review,
    List<String>? images,
    int? shippingCharges,
    int? quantity,
    int? sold,
    int? view,
    bool? isOutOfStock,
    bool? isNewCollection,
    bool? isSelect,
    String? createStatus,
    bool? createIsApproved,
    String? updateStatus,
    bool? updateIsApproved,
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
    _price = price;
    _review = review;
    _images = images;
    _shippingCharges = shippingCharges;
    _quantity = quantity;
    _sold = sold;
    _view = view;
    _isOutOfStock = isOutOfStock;
    _isNewCollection = isNewCollection;
    _isSelect = isSelect;
    _createStatus = createStatus;
    _createIsApproved = createIsApproved;
    _updateStatus = updateStatus;
    _updateIsApproved = updateIsApproved;
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

  Product.fromJson(dynamic json) {
    _id = json['_id'];
    _productCode = json['productCode'];
    _price = json['price'];
    _review = json['review'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _shippingCharges = json['shippingCharges'];
    _quantity = json['quantity'];
    _sold = json['sold'];
    _view = json['view'];
    _isOutOfStock = json['isOutOfStock'];
    _isNewCollection = json['isNewCollection'];
    _isSelect = json['isSelect'];
    _createStatus = json['createStatus'];
    _createIsApproved = json['createIsApproved'];
    _updateStatus = json['updateStatus'];
    _updateIsApproved = json['updateIsApproved'];
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
  int? _price;
  int? _review;
  List<String>? _images;
  int? _shippingCharges;
  int? _quantity;
  int? _sold;
  int? _view;
  bool? _isOutOfStock;
  bool? _isNewCollection;
  bool? _isSelect;
  String? _createStatus;
  bool? _createIsApproved;
  String? _updateStatus;
  bool? _updateIsApproved;
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

  Product copyWith({
    String? id,
    String? productCode,
    int? price,
    int? review,
    List<String>? images,
    int? shippingCharges,
    int? quantity,
    int? sold,
    int? view,
    bool? isOutOfStock,
    bool? isNewCollection,
    bool? isSelect,
    String? createStatus,
    bool? createIsApproved,
    String? updateStatus,
    bool? updateIsApproved,
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
      Product(
        id: id ?? _id,
        productCode: productCode ?? _productCode,
        price: price ?? _price,
        review: review ?? _review,
        images: images ?? _images,
        shippingCharges: shippingCharges ?? _shippingCharges,
        quantity: quantity ?? _quantity,
        sold: sold ?? _sold,
        view: view ?? _view,
        isOutOfStock: isOutOfStock ?? _isOutOfStock,
        isNewCollection: isNewCollection ?? _isNewCollection,
        isSelect: isSelect ?? _isSelect,
        createStatus: createStatus ?? _createStatus,
        createIsApproved: createIsApproved ?? _createIsApproved,
        updateStatus: updateStatus ?? _updateStatus,
        updateIsApproved: updateIsApproved ?? _updateIsApproved,
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

  int? get price => _price;

  int? get review => _review;

  List<String>? get images => _images;

  int? get shippingCharges => _shippingCharges;

  int? get quantity => _quantity;

  int? get sold => _sold;

  int? get view => _view;

  bool? get isOutOfStock => _isOutOfStock;

  bool? get isNewCollection => _isNewCollection;

  bool? get isSelect => _isSelect;

  String? get createStatus => _createStatus;

  bool? get createIsApproved => _createIsApproved;

  String? get updateStatus => _updateStatus;

  bool? get updateIsApproved => _updateIsApproved;

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
    map['price'] = _price;
    map['review'] = _review;
    map['images'] = _images;
    map['shippingCharges'] = _shippingCharges;
    map['quantity'] = _quantity;
    map['sold'] = _sold;
    map['view'] = _view;
    map['isOutOfStock'] = _isOutOfStock;
    map['isNewCollection'] = _isNewCollection;
    map['isSelect'] = _isSelect;
    map['createStatus'] = _createStatus;
    map['createIsApproved'] = _createIsApproved;
    map['updateStatus'] = _updateStatus;
    map['updateIsApproved'] = _updateIsApproved;
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
