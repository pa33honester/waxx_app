// ignore_for_file: file_names
import 'dart:convert';

CheckOutModel checkOutModelFromJson(String str) => CheckOutModel.fromJson(json.decode(str));

String checkOutModelToJson(CheckOutModel data) => json.encode(data.toJson());

class CheckOutModel {
  CheckOutModel({
    bool? status,
    String? message,
    Cart? cart,
    PromoCode? promoCode,
  }) {
    _status = status;
    _message = message;
    _cart = cart;
    _promoCode = promoCode;
  }

  CheckOutModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
    _promoCode = json['promoCode'] != null ? PromoCode.fromJson(json['promoCode']) : null;
  }

  bool? _status;
  String? _message;
  Cart? _cart;
  PromoCode? _promoCode;

  CheckOutModel copyWith({
    bool? status,
    String? message,
    Cart? cart,
    PromoCode? promoCode,
  }) =>
      CheckOutModel(
        status: status ?? _status,
        message: message ?? _message,
        cart: cart ?? _cart,
        promoCode: promoCode ?? _promoCode,
      );

  bool? get status => _status;

  String? get message => _message;

  Cart? get cart => _cart;

  PromoCode? get promoCode => _promoCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_cart != null) {
      map['cart'] = _cart?.toJson();
    }
    if (_promoCode != null) {
      map['promoCode'] = _promoCode?.toJson();
    }
    return map;
  }
}

PromoCode promoCodeFromJson(String str) => PromoCode.fromJson(json.decode(str));

String promoCodeToJson(PromoCode data) => json.encode(data.toJson());

class PromoCode {
  PromoCode({
    String? id,
    int? discountAmount,
    List<String>? conditions,
    String? promoCode,
    int? discountType,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _discountAmount = discountAmount;
    _conditions = conditions;
    _promoCode = promoCode;
    _discountType = discountType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  PromoCode.fromJson(dynamic json) {
    _id = json['_id'];
    _discountAmount = json['discountAmount'];
    _conditions = json['conditions'] != null ? json['conditions'].cast<String>() : [];
    _promoCode = json['promoCode'];
    _discountType = json['discountType'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  int? _discountAmount;
  List<String>? _conditions;
  String? _promoCode;
  int? _discountType;
  String? _createdAt;
  String? _updatedAt;

  PromoCode copyWith({
    String? id,
    int? discountAmount,
    List<String>? conditions,
    String? promoCode,
    int? discountType,
    String? createdAt,
    String? updatedAt,
  }) =>
      PromoCode(
        id: id ?? _id,
        discountAmount: discountAmount ?? _discountAmount,
        conditions: conditions ?? _conditions,
        promoCode: promoCode ?? _promoCode,
        discountType: discountType ?? _discountType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  int? get discountAmount => _discountAmount;

  List<String>? get conditions => _conditions;

  String? get promoCode => _promoCode;

  int? get discountType => _discountType;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['discountAmount'] = _discountAmount;
    map['conditions'] = _conditions;
    map['promoCode'] = _promoCode;
    map['discountType'] = _discountType;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    String? id,
    int? totalPrice,
    int? totalItems,
    List<Items>? items,
  }) {
    _id = id;
    _totalPrice = totalPrice;
    _totalItems = totalItems;
    _items = items;
  }

  Cart.fromJson(dynamic json) {
    _id = json['_id'];
    _totalPrice = json['totalPrice'];
    _totalItems = json['totalItems'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }

  String? _id;
  int? _totalPrice;
  int? _totalItems;
  List<Items>? _items;

  Cart copyWith({
    String? id,
    int? totalPrice,
    int? totalItems,
    List<Items>? items,
  }) =>
      Cart(
        id: id ?? _id,
        totalPrice: totalPrice ?? _totalPrice,
        totalItems: totalItems ?? _totalItems,
        items: items ?? _items,
      );

  String? get id => _id;

  int? get totalPrice => _totalPrice;

  int? get totalItems => _totalItems;

  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['totalPrice'] = _totalPrice;
    map['totalItems'] = _totalItems;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items({
    ProductId? productId,
    String? sellerId,
    int? productQuantity,
    String? size,
    String? color,
    String? id,
  }) {
    _productId = productId;
    _sellerId = sellerId;
    _productQuantity = productQuantity;
    _size = size;
    _color = color;
    _id = id;
  }

  Items.fromJson(dynamic json) {
    _productId = json['productId'] != null ? ProductId.fromJson(json['productId']) : null;
    _sellerId = json['sellerId'];
    _productQuantity = json['productQuantity'];
    _size = json['size'];
    _color = json['color'];
    _id = json['_id'];
  }

  ProductId? _productId;
  String? _sellerId;
  int? _productQuantity;
  String? _size;
  String? _color;
  String? _id;

  Items copyWith({
    ProductId? productId,
    String? sellerId,
    int? productQuantity,
    String? size,
    String? color,
    String? id,
  }) =>
      Items(
        productId: productId ?? _productId,
        sellerId: sellerId ?? _sellerId,
        productQuantity: productQuantity ?? _productQuantity,
        size: size ?? _size,
        color: color ?? _color,
        id: id ?? _id,
      );

  ProductId? get productId => _productId;

  String? get sellerId => _sellerId;

  int? get productQuantity => _productQuantity;

  String? get size => _size;

  String? get color => _color;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productId != null) {
      map['productId'] = _productId?.toJson();
    }
    map['sellerId'] = _sellerId;
    map['productQuantity'] = _productQuantity;
    map['size'] = _size;
    map['color'] = _color;
    map['_id'] = _id;
    return map;
  }
}

ProductId productIdFromJson(String str) => ProductId.fromJson(json.decode(str));

String productIdToJson(ProductId data) => json.encode(data.toJson());

class ProductId {
  ProductId({
    String? id,
    int? price,
    String? productName,
    String? seller,
    String? mainImage,
  }) {
    _id = id;
    _price = price;
    _productName = productName;
    _seller = seller;
    _mainImage = mainImage;
  }

  ProductId.fromJson(dynamic json) {
    _id = json['_id'];
    _price = json['price'];
    _productName = json['productName'];
    _seller = json['seller'];
    _mainImage = json['mainImage'];
  }

  String? _id;
  int? _price;
  String? _productName;
  String? _seller;
  String? _mainImage;

  ProductId copyWith({
    String? id,
    int? price,
    String? productName,
    String? seller,
    String? mainImage,
  }) =>
      ProductId(
        id: id ?? _id,
        price: price ?? _price,
        productName: productName ?? _productName,
        seller: seller ?? _seller,
        mainImage: mainImage ?? _mainImage,
      );

  String? get id => _id;

  int? get price => _price;

  String? get productName => _productName;

  String? get seller => _seller;

  String? get mainImage => _mainImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['price'] = _price;
    map['productName'] = _productName;
    map['seller'] = _seller;
    map['mainImage'] = _mainImage;
    return map;
  }
}
