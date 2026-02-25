// ignore_for_file: file_names
import 'dart:convert';

GetFilterwiseProductModel getFilterwiseProductModelFromJson(String str) =>
    GetFilterwiseProductModel.fromJson(json.decode(str));

String getFilterwiseProductModelToJson(GetFilterwiseProductModel data) => json.encode(data.toJson());

class GetFilterwiseProductModel {
  GetFilterwiseProductModel({
    bool? status,
    String? message,
    List<Product>? product,
  }) {
    _status = status;
    _message = message;
    _product = product;
  }

  GetFilterwiseProductModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['product'] != null) {
      _product = [];
      json['product'].forEach((v) {
        _product?.add(Product.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Product>? _product;

  GetFilterwiseProductModel copyWith({
    bool? status,
    String? message,
    List<Product>? product,
  }) =>
      GetFilterwiseProductModel(
        status: status ?? _status,
        message: message ?? _message,
        product: product ?? _product,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Product>? get product => _product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_product != null) {
      map['product'] = _product?.map((v) => v.toJson()).toList();
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
    int? shippingCharges,
    List<String>? images,
    int? review,
    int? sold,
    bool? isOutOfStock,
    String? createStatus,
    String? productName,
    String? description,
    String? category,
    String? seller,
    String? mainImage,
    bool? isFavorite,
    int? ratingAverage,
  }) {
    _id = id;
    _productCode = productCode;
    _price = price;
    _shippingCharges = shippingCharges;
    _images = images;
    _review = review;
    _sold = sold;
    _isOutOfStock = isOutOfStock;
    _createStatus = createStatus;
    _productName = productName;
    _description = description;
    _category = category;
    _seller = seller;
    _mainImage = mainImage;
    _isFavorite = isFavorite;
    _ratingAverage = ratingAverage;
  }

  Product.fromJson(dynamic json) {
    _id = json['_id'];
    _productCode = json['productCode'];
    _price = json['price'];
    _shippingCharges = json['shippingCharges'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _review = json['review'];
    _sold = json['sold'];
    _isOutOfStock = json['isOutOfStock'];
    _createStatus = json['createStatus'];
    _productName = json['productName'];
    _description = json['description'];
    _category = json['category'];
    _seller = json['seller'];
    _mainImage = json['mainImage'];
    _isFavorite = json['isFavorite'];
    _ratingAverage = json['ratingAverage'];
  }

  String? _id;
  String? _productCode;
  int? _price;
  int? _shippingCharges;
  List<String>? _images;
  int? _review;
  int? _sold;
  bool? _isOutOfStock;
  String? _createStatus;
  String? _productName;
  String? _description;
  String? _category;
  String? _seller;
  String? _mainImage;
  bool? _isFavorite;
  int? _ratingAverage;

  Product copyWith({
    String? id,
    String? productCode,
    int? price,
    int? shippingCharges,
    List<String>? images,
    int? review,
    int? sold,
    bool? isOutOfStock,
    String? createStatus,
    String? productName,
    String? description,
    String? category,
    String? seller,
    String? mainImage,
    bool? isFavorite,
    int? ratingAverage,
  }) =>
      Product(
        id: id ?? _id,
        productCode: productCode ?? _productCode,
        price: price ?? _price,
        shippingCharges: shippingCharges ?? _shippingCharges,
        images: images ?? _images,
        review: review ?? _review,
        sold: sold ?? _sold,
        isOutOfStock: isOutOfStock ?? _isOutOfStock,
        createStatus: createStatus ?? _createStatus,
        productName: productName ?? _productName,
        description: description ?? _description,
        category: category ?? _category,
        seller: seller ?? _seller,
        mainImage: mainImage ?? _mainImage,
        isFavorite: isFavorite ?? _isFavorite,
        ratingAverage: ratingAverage ?? _ratingAverage,
      );

  String? get id => _id;

  String? get productCode => _productCode;

  int? get price => _price;

  int? get shippingCharges => _shippingCharges;

  List<String>? get images => _images;

  int? get review => _review;

  int? get sold => _sold;

  bool? get isOutOfStock => _isOutOfStock;

  String? get createStatus => _createStatus;

  String? get productName => _productName;

  String? get description => _description;

  String? get category => _category;

  String? get seller => _seller;

  String? get mainImage => _mainImage;

  bool? get isFavorite => _isFavorite;

  int? get ratingAverage => _ratingAverage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['productCode'] = _productCode;
    map['price'] = _price;
    map['shippingCharges'] = _shippingCharges;
    map['images'] = _images;
    map['review'] = _review;
    map['sold'] = _sold;
    map['isOutOfStock'] = _isOutOfStock;
    map['createStatus'] = _createStatus;
    map['productName'] = _productName;
    map['description'] = _description;
    map['category'] = _category;
    map['seller'] = _seller;
    map['mainImage'] = _mainImage;
    map['isFavorite'] = _isFavorite;
    map['ratingAverage'] = _ratingAverage;
    return map;
  }
}
