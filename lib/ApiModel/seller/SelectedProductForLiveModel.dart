// ignore_for_file: file_names
import 'dart:convert';

SelectedProductForLiveModel selectedProductForLiveModelFromJson(String str) =>
    SelectedProductForLiveModel.fromJson(json.decode(str));

String selectedProductForLiveModelToJson(SelectedProductForLiveModel data) => json.encode(data.toJson());

class SelectedProductForLiveModel {
  SelectedProductForLiveModel({
    bool? status,
    String? message,
    int? totalSelectedProducts,
    List<SelectedProducts>? selectedProducts,
    String? liveSellingHistoryId,
  }) {
    _status = status;
    _message = message;
    _totalSelectedProducts = totalSelectedProducts;
    _selectedProducts = selectedProducts;
    _liveSellingHistoryId = liveSellingHistoryId;
  }

  SelectedProductForLiveModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _totalSelectedProducts = json['totalSelectedProducts'];
    if (json['SelectedProducts'] != null) {
      _selectedProducts = [];
      json['SelectedProducts'].forEach((v) {
        _selectedProducts?.add(SelectedProducts.fromJson(v));
      });
    }
    _liveSellingHistoryId = json['liveSellingHistoryId'];
  }

  bool? _status;
  String? _message;
  int? _totalSelectedProducts;
  List<SelectedProducts>? _selectedProducts;
  String? _liveSellingHistoryId;

  SelectedProductForLiveModel copyWith({
    bool? status,
    String? message,
    int? totalSelectedProducts,
    List<SelectedProducts>? selectedProducts,
    String? liveSellingHistoryId,
  }) =>
      SelectedProductForLiveModel(
        status: status ?? _status,
        message: message ?? _message,
        totalSelectedProducts: totalSelectedProducts ?? _totalSelectedProducts,
        selectedProducts: selectedProducts ?? _selectedProducts,
        liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
      );

  bool? get status => _status;

  String? get message => _message;

  int? get totalSelectedProducts => _totalSelectedProducts;

  List<SelectedProducts>? get selectedProducts => _selectedProducts;

  String? get liveSellingHistoryId => _liveSellingHistoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['totalSelectedProducts'] = _totalSelectedProducts;
    if (_selectedProducts != null) {
      map['SelectedProducts'] = _selectedProducts?.map((v) => v.toJson()).toList();
    }
    map['liveSellingHistoryId'] = _liveSellingHistoryId;
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

  SelectedProducts.fromJson(dynamic json) {
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

  SelectedProducts copyWith({
    String? id,
    int? price,
    bool? isSelect,
    String? productName,
    String? seller,
    String? mainImage,
  }) =>
      SelectedProducts(
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
