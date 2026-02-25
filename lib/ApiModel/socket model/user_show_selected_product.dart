import 'dart:convert';

UserShowSelectedProduct userShowSelectedProductFromJson(String str) =>
    UserShowSelectedProduct.fromJson(json.decode(str));

String userShowSelectedProductToJson(UserShowSelectedProduct data) => json.encode(data.toJson());

class UserShowSelectedProduct {
  UserShowSelectedProduct({
    List<AddProduct>? addProduct,
    String? liveSellingHistoryId,
  }) {
    _addProduct = addProduct;
    _liveSellingHistoryId = liveSellingHistoryId;
  }

  UserShowSelectedProduct.fromJson(dynamic json) {
    if (json['addProduct'] != null) {
      _addProduct = [];
      json['addProduct'].forEach((v) {
        _addProduct?.add(AddProduct.fromJson(v));
      });
    }
    _liveSellingHistoryId = json['liveSellingHistoryId'];
  }

  List<AddProduct>? _addProduct;
  String? _liveSellingHistoryId;

  UserShowSelectedProduct copyWith({
    List<AddProduct>? addProduct,
    String? liveSellingHistoryId,
  }) =>
      UserShowSelectedProduct(
        addProduct: addProduct ?? _addProduct,
        liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
      );

  List<AddProduct>? get addProduct => _addProduct;

  String? get liveSellingHistoryId => _liveSellingHistoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_addProduct != null) {
      map['addProduct'] = _addProduct?.map((v) => v.toJson()).toList();
    }
    map['liveSellingHistoryId'] = _liveSellingHistoryId;
    return map;
  }
}

AddProduct addProductFromJson(String str) => AddProduct.fromJson(json.decode(str));

String addProductToJson(AddProduct data) => json.encode(data.toJson());

class AddProduct {
  AddProduct({
    String? id,
    int? price,
    bool? isSelect,
    String? productName,
    String? seller,
    String? mainImage,
  }) {
    _id = id;
    _price = price;
    _isSelect = isSelect;
    _productName = productName;
    _seller = seller;
    _mainImage = mainImage;
  }

  AddProduct.fromJson(dynamic json) {
    _id = json['_id'];
    _price = json['price'];
    _isSelect = json['isSelect'];
    _productName = json['productName'];
    _seller = json['seller'];
    _mainImage = json['mainImage'];
  }

  String? _id;
  int? _price;
  bool? _isSelect;
  String? _productName;
  String? _seller;
  String? _mainImage;

  AddProduct copyWith({
    String? id,
    int? price,
    bool? isSelect,
    String? productName,
    String? seller,
    String? mainImage,
  }) =>
      AddProduct(
        id: id ?? _id,
        price: price ?? _price,
        isSelect: isSelect ?? _isSelect,
        productName: productName ?? _productName,
        seller: seller ?? _seller,
        mainImage: mainImage ?? _mainImage,
      );

  String? get id => _id;

  int? get price => _price;

  bool? get isSelect => _isSelect;

  String? get productName => _productName;

  String? get seller => _seller;

  String? get mainImage => _mainImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['price'] = _price;
    map['isSelect'] = _isSelect;
    map['productName'] = _productName;
    map['seller'] = _seller;
    map['mainImage'] = _mainImage;
    return map;
  }
}
