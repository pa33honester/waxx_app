// ignore_for_file: file_names
import 'dart:convert';

LiveProductSelect liveProductSelectFromJson(String str) => LiveProductSelect.fromJson(json.decode(str));

String liveProductSelectToJson(LiveProductSelect data) => json.encode(data.toJson());

class LiveProductSelect {
  LiveProductSelect({
    bool? status,
    String? message,
    Product? product,
  }) {
    _status = status;
    _message = message;
    _product = product;
  }

  LiveProductSelect.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  bool? _status;
  String? _message;
  Product? _product;

  LiveProductSelect copyWith({
    bool? status,
    String? message,
    Product? product,
  }) =>
      LiveProductSelect(
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
    num? price,
    num? review,
    List<String>? images,
    List<String>? sizes,
    num? quantity,
    num? sold,
    bool? isOutOfStock,
    bool? isNewCollection,
    bool? isSelect,
    dynamic lastSeenAt,
    dynamic lastSearchedAt,
    num? searchCount,
    String? productName,
    String? description,
    String? category,
    String? seller,
    num? shippingCharges,
    String? mainImage,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _productCode = productCode;
    _price = price;
    _review = review;
    _images = images;
    _sizes = sizes;
    _quantity = quantity;
    _sold = sold;
    _isOutOfStock = isOutOfStock;
    _isNewCollection = isNewCollection;
    _isSelect = isSelect;
    _lastSeenAt = lastSeenAt;
    _lastSearchedAt = lastSearchedAt;
    _searchCount = searchCount;
    _productName = productName;
    _description = description;
    _category = category;
    _seller = seller;
    _shippingCharges = shippingCharges;
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
    _sizes = json['sizes'] != null ? json['sizes'].cast<String>() : [];
    _quantity = json['quantity'];
    _sold = json['sold'];
    _isOutOfStock = json['isOutOfStock'];
    _isNewCollection = json['isNewCollection'];
    _isSelect = json['isSelect'];
    _lastSeenAt = json['lastSeenAt'];
    _lastSearchedAt = json['lastSearchedAt'];
    _searchCount = json['searchCount'];
    _productName = json['productName'];
    _description = json['description'];
    _category = json['category'];
    _seller = json['seller'];
    _shippingCharges = json['shippingCharges'];
    _mainImage = json['mainImage'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _productCode;
  num? _price;
  num? _review;
  List<String>? _images;
  List<String>? _sizes;
  num? _quantity;
  num? _sold;
  bool? _isOutOfStock;
  bool? _isNewCollection;
  bool? _isSelect;
  dynamic _lastSeenAt;
  dynamic _lastSearchedAt;
  num? _searchCount;
  String? _productName;
  String? _description;
  String? _category;
  String? _seller;
  num? _shippingCharges;
  String? _mainImage;
  String? _createdAt;
  String? _updatedAt;

  Product copyWith({
    String? id,
    String? productCode,
    num? price,
    num? review,
    List<String>? images,
    List<String>? sizes,
    num? quantity,
    num? sold,
    bool? isOutOfStock,
    bool? isNewCollection,
    bool? isSelect,
    dynamic lastSeenAt,
    dynamic lastSearchedAt,
    num? searchCount,
    String? productName,
    String? description,
    String? category,
    String? seller,
    num? shippingCharges,
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
        sizes: sizes ?? _sizes,
        quantity: quantity ?? _quantity,
        sold: sold ?? _sold,
        isOutOfStock: isOutOfStock ?? _isOutOfStock,
        isNewCollection: isNewCollection ?? _isNewCollection,
        isSelect: isSelect ?? _isSelect,
        lastSeenAt: lastSeenAt ?? _lastSeenAt,
        lastSearchedAt: lastSearchedAt ?? _lastSearchedAt,
        searchCount: searchCount ?? _searchCount,
        productName: productName ?? _productName,
        description: description ?? _description,
        category: category ?? _category,
        seller: seller ?? _seller,
        shippingCharges: shippingCharges ?? _shippingCharges,
        mainImage: mainImage ?? _mainImage,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get productCode => _productCode;

  num? get price => _price;

  num? get review => _review;

  List<String>? get images => _images;

  List<String>? get sizes => _sizes;

  num? get quantity => _quantity;

  num? get sold => _sold;

  bool? get isOutOfStock => _isOutOfStock;

  bool? get isNewCollection => _isNewCollection;

  bool? get isSelect => _isSelect;

  dynamic get lastSeenAt => _lastSeenAt;

  dynamic get lastSearchedAt => _lastSearchedAt;

  num? get searchCount => _searchCount;

  String? get productName => _productName;

  String? get description => _description;

  String? get category => _category;

  String? get seller => _seller;

  num? get shippingCharges => _shippingCharges;

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
    map['sizes'] = _sizes;
    map['quantity'] = _quantity;
    map['sold'] = _sold;
    map['isOutOfStock'] = _isOutOfStock;
    map['isNewCollection'] = _isNewCollection;
    map['isSelect'] = _isSelect;
    map['lastSeenAt'] = _lastSeenAt;
    map['lastSearchedAt'] = _lastSearchedAt;
    map['searchCount'] = _searchCount;
    map['productName'] = _productName;
    map['description'] = _description;
    map['category'] = _category;
    map['seller'] = _seller;
    map['shippingCharges'] = _shippingCharges;
    map['mainImage'] = _mainImage;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
