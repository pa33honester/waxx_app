/*
// ignore_for_file: file_names
import 'dart:convert';

AddProductToCartModel addProductToCartModelFromJson(String str) =>
    AddProductToCartModel.fromJson(json.decode(str));

String addProductToCartModelToJson(AddProductToCartModel data) => json.encode(data.toJson());

class AddProductToCartModel {
  AddProductToCartModel({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  AddProductToCartModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  AddProductToCartModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) =>
      AddProductToCartModel(
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
    int? totalPrice,
    int? totalItems,
    List<Items>? items,
    String? userId,
  }) {
    _id = id;
    _totalPrice = totalPrice;
    _totalItems = totalItems;
    _items = items;
    _userId = userId;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _totalPrice = json['totalPrice'];
    _totalItems = json['totalItems'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _userId = json['userId'];
  }

  String? _id;
  int? _totalPrice;
  int? _totalItems;
  List<Items>? _items;
  String? _userId;

  Data copyWith({
    String? id,
    int? totalPrice,
    int? totalItems,
    List<Items>? items,
    String? userId,
  }) =>
      Data(
        id: id ?? _id,
        totalPrice: totalPrice ?? _totalPrice,
        totalItems: totalItems ?? _totalItems,
        items: items ?? _items,
        userId: userId ?? _userId,
      );

  String? get id => _id;

  int? get totalPrice => _totalPrice;

  int? get totalItems => _totalItems;

  List<Items>? get items => _items;

  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['totalPrice'] = _totalPrice;
    map['totalItems'] = _totalItems;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['userId'] = _userId;
    return map;
  }
}

/// sellerId : "645f4a800e7cd960a30d73ed"
/// productQuantity : 1
/// size : "s"
/// _id : "646b3be3901a01bb82f9bbe9"

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items({
    ProductId? productId,
    String? sellerId,
    int? productQuantity,
    String? size,
    String? id,
  }) {
    _productId = productId;
    _sellerId = sellerId;
    _productQuantity = productQuantity;
    _size = size;
    _id = id;
  }

  Items.fromJson(dynamic json) {
    _productId = json['productId'] != null ? ProductId.fromJson(json['productId']) : null;
    _sellerId = json['sellerId'];
    _productQuantity = json['productQuantity'];
    _size = json['size'];
    _id = json['_id'];
  }

  ProductId? _productId;
  String? _sellerId;
  int? _productQuantity;
  String? _size;
  String? _id;

  Items copyWith({
    ProductId? productId,
    String? sellerId,
    int? productQuantity,
    String? size,
    String? id,
  }) =>
      Items(
        productId: productId ?? _productId,
        sellerId: sellerId ?? _sellerId,
        productQuantity: productQuantity ?? _productQuantity,
        size: size ?? _size,
        id: id ?? _id,
      );

  ProductId? get productId => _productId;

  String? get sellerId => _sellerId;

  int? get productQuantity => _productQuantity;

  String? get size => _size;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productId != null) {
      map['productId'] = _productId?.toJson();
    }
    map['sellerId'] = _sellerId;
    map['productQuantity'] = _productQuantity;
    map['size'] = _size;
    map['_id'] = _id;
    return map;
  }
}

ProductId productIdFromJson(String str) => ProductId.fromJson(json.decode(str));

String productIdToJson(ProductId data) => json.encode(data.toJson());

class ProductId {
  ProductId({
    String? id,
    String? productCode,
    int? price,
    String? productName,
    String? seller,
    String? mainImage,
  }) {
    _id = id;
    _productCode = productCode;
    _price = price;
    _productName = productName;
    _seller = seller;
    _mainImage = mainImage;
  }

  ProductId.fromJson(dynamic json) {
    _id = json['_id'];
    _productCode = json['productCode'];
    _price = json['price'];
    _productName = json['productName'];
    _seller = json['seller'];
    _mainImage = json['mainImage'];
  }

  String? _id;
  String? _productCode;
  int? _price;
  String? _productName;
  String? _seller;
  String? _mainImage;

  ProductId copyWith({
    String? id,
    String? productCode,
    int? price,
    String? productName,
    String? seller,
    String? mainImage,
  }) =>
      ProductId(
        id: id ?? _id,
        productCode: productCode ?? _productCode,
        price: price ?? _price,
        productName: productName ?? _productName,
        seller: seller ?? _seller,
        mainImage: mainImage ?? _mainImage,
      );

  String? get id => _id;

  String? get productCode => _productCode;

  int? get price => _price;

  String? get productName => _productName;

  String? get seller => _seller;

  String? get mainImage => _mainImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['productCode'] = _productCode;
    map['price'] = _price;
    map['productName'] = _productName;
    map['seller'] = _seller;
    map['mainImage'] = _mainImage;
    return map;
  }
}
*/
class AddProductToCartModel {
  final bool status;
  final String message;
  final Data? data;

  AddProductToCartModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddProductToCartModel.fromJson(Map<String, dynamic> json) {
    return AddProductToCartModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final num totalShippingCharges;
  final num subTotal;
  final num total;
  final num finalTotal;
  final int totalItems;
  final String id;
  final List<Item> items;
  final String userId;

  Data({
    required this.totalShippingCharges,
    required this.subTotal,
    required this.total,
    required this.finalTotal,
    required this.totalItems,
    required this.id,
    required this.items,
    required this.userId,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalShippingCharges: json['totalShippingCharges'] ?? 0,
      subTotal: json['subTotal'] ?? 0,
      total: json['total'] ?? 0,
      finalTotal: json['finalTotal'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      id: json['_id'] ?? '',
      items: (json['items'] as List<dynamic>?)?.map((item) => Item.fromJson(item)).toList() ?? [],
      userId: json['userId'] ?? '',
    );
  }
}

class Item {
  final Product productId;
  final String sellerId;
  final num purchasedTimeProductPrice;
  final num purchasedTimeShippingCharges;
  final String productCode;
  final int productQuantity;
  final List<Attribute> attributesArray;
  final String id;

  Item({
    required this.productId,
    required this.sellerId,
    required this.purchasedTimeProductPrice,
    required this.purchasedTimeShippingCharges,
    required this.productCode,
    required this.productQuantity,
    required this.attributesArray,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: Product.fromJson(json['productId']),
      sellerId: json['sellerId'] ?? '',
      purchasedTimeProductPrice: json['purchasedTimeProductPrice'] ?? 0,
      purchasedTimeShippingCharges: json['purchasedTimeShippingCharges'] ?? 0,
      productCode: json['productCode'] ?? '',
      productQuantity: json['productQuantity'] ?? 0,
      attributesArray: (json['attributesArray'] as List<dynamic>?)?.map((attr) => Attribute.fromJson(attr)).toList() ?? [],
      id: json['_id'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String productName;
  final String mainImage;

  Product({
    required this.id,
    required this.productName,
    required this.mainImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      mainImage: json['mainImage'] ?? '',
    );
  }
}

class Attribute {
  final String name;
  final String value;
  final String id;

  Attribute({
    required this.name,
    required this.value,
    required this.id,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
