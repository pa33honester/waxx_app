// ignore_for_file: file_names
import 'dart:convert';

GetNewCollectionModel getNewCollectionModelFromJson(String str) => GetNewCollectionModel.fromJson(json.decode(str));

String getNewCollectionModelToJson(GetNewCollectionModel data) => json.encode(data.toJson());

class GetNewCollectionModel {
  GetNewCollectionModel({
    bool? status,
    String? message,
    List<Products>? products,
  }) {
    _status = status;
    _message = message;
    _products = products;
  }

  GetNewCollectionModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Products>? _products;

  GetNewCollectionModel copyWith({
    bool? status,
    String? message,
    List<Products>? products,
  }) =>
      GetNewCollectionModel(
        status: status ?? _status,
        message: message ?? _message,
        products: products ?? _products,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Products>? get products => _products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    String? id,
    num? price,
    int? review,
    List<String>? images,
    List<String>? sizes,
    int? sold,
    bool? isOutOfStock,
    bool? isNewCollection,
    String? productName,
    String? description,
    String? category,
    String? seller,
    num? shippingCharges,
    String? mainImage,
    bool? isFavorite,
  }) {
    _id = id;
    _price = price;
    _review = review;
    _images = images;
    _sizes = sizes;
    _sold = sold;
    _isOutOfStock = isOutOfStock;
    _isNewCollection = isNewCollection;
    _productName = productName;
    _description = description;
    _category = category;
    _seller = seller;
    _shippingCharges = shippingCharges;
    _mainImage = mainImage;
    _isFavorite = isFavorite;
  }

  Products.fromJson(dynamic json) {
    _id = json['_id'];
    _price = json['price'];
    _review = json['review'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _sizes = json['sizes'] != null ? json['sizes'].cast<String>() : [];
    _sold = json['sold'];
    _isOutOfStock = json['isOutOfStock'];
    _isNewCollection = json['isNewCollection'];
    _productName = json['productName'];
    _description = json['description'];
    _category = json['category'];
    _seller = json['seller'];
    _shippingCharges = json['shippingCharges'];
    _mainImage = json['mainImage'];
    _isFavorite = json['isFavorite'];
  }

  String? _id;
  num? _price;
  int? _review;
  List<String>? _images;
  List<String>? _sizes;
  int? _sold;
  bool? _isOutOfStock;
  bool? _isNewCollection;
  String? _productName;
  String? _description;
  String? _category;
  String? _seller;
  num? _shippingCharges;
  String? _mainImage;
  bool? _isFavorite;

  Products copyWith({
    String? id,
    num? price,
    int? review,
    List<String>? images,
    List<String>? sizes,
    int? sold,
    bool? isOutOfStock,
    bool? isNewCollection,
    String? productName,
    String? description,
    String? category,
    String? seller,
    num? shippingCharges,
    String? mainImage,
    bool? isFavorite,
  }) =>
      Products(
        id: id ?? _id,
        price: price ?? _price,
        review: review ?? _review,
        images: images ?? _images,
        sizes: sizes ?? _sizes,
        sold: sold ?? _sold,
        isOutOfStock: isOutOfStock ?? _isOutOfStock,
        isNewCollection: isNewCollection ?? _isNewCollection,
        productName: productName ?? _productName,
        description: description ?? _description,
        category: category ?? _category,
        seller: seller ?? _seller,
        shippingCharges: shippingCharges ?? _shippingCharges,
        mainImage: mainImage ?? _mainImage,
        isFavorite: isFavorite ?? _isFavorite,
      );

  String? get id => _id;

  num? get price => _price;

  int? get review => _review;

  List<String>? get images => _images;

  List<String>? get sizes => _sizes;

  int? get sold => _sold;

  bool? get isOutOfStock => _isOutOfStock;

  bool? get isNewCollection => _isNewCollection;

  String? get productName => _productName;

  String? get description => _description;

  String? get category => _category;

  String? get seller => _seller;

  num? get shippingCharges => _shippingCharges;

  String? get mainImage => _mainImage;

  bool? get isFavorite => _isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['price'] = _price;
    map['review'] = _review;
    map['images'] = _images;
    map['sizes'] = _sizes;
    map['sold'] = _sold;
    map['isOutOfStock'] = _isOutOfStock;
    map['isNewCollection'] = _isNewCollection;
    map['productName'] = _productName;
    map['description'] = _description;
    map['category'] = _category;
    map['seller'] = _seller;
    map['shippingCharges'] = _shippingCharges;
    map['mainImage'] = _mainImage;
    map['isFavorite'] = _isFavorite;
    return map;
  }
}
