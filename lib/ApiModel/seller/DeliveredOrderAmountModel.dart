import 'dart:convert';
DeliveredOrderAmountModel deliveredOrderAmountModelFromJson(String str) => DeliveredOrderAmountModel.fromJson(json.decode(str));
String deliveredOrderAmountModelToJson(DeliveredOrderAmountModel data) => json.encode(data.toJson());
class DeliveredOrderAmountModel {
  DeliveredOrderAmountModel({
      bool? status, 
      String? message, 
      List<SellerPendingWithdrawableAmount>? sellerPendingWithdrawableAmount,}){
    _status = status;
    _message = message;
    _sellerPendingWithdrawableAmount = sellerPendingWithdrawableAmount;
}

  DeliveredOrderAmountModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['sellerPendingWithdrawableAmount'] != null) {
      _sellerPendingWithdrawableAmount = [];
      json['sellerPendingWithdrawableAmount'].forEach((v) {
        _sellerPendingWithdrawableAmount?.add(SellerPendingWithdrawableAmount.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<SellerPendingWithdrawableAmount>? _sellerPendingWithdrawableAmount;
DeliveredOrderAmountModel copyWith({  bool? status,
  String? message,
  List<SellerPendingWithdrawableAmount>? sellerPendingWithdrawableAmount,
}) => DeliveredOrderAmountModel(  status: status ?? _status,
  message: message ?? _message,
  sellerPendingWithdrawableAmount: sellerPendingWithdrawableAmount ?? _sellerPendingWithdrawableAmount,
);
  bool? get status => _status;
  String? get message => _message;
  List<SellerPendingWithdrawableAmount>? get sellerPendingWithdrawableAmount => _sellerPendingWithdrawableAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_sellerPendingWithdrawableAmount != null) {
      map['sellerPendingWithdrawableAmount'] = _sellerPendingWithdrawableAmount?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

SellerPendingWithdrawableAmount sellerPendingWithdrawableAmountFromJson(String str) => SellerPendingWithdrawableAmount.fromJson(json.decode(str));
String sellerPendingWithdrawableAmountToJson(SellerPendingWithdrawableAmount data) => json.encode(data.toJson());
class SellerPendingWithdrawableAmount {
  SellerPendingWithdrawableAmount({
      String? id, 
      String? orderId, 
      num? amount, 
      String? paymentGateway, 
      ProductId? productId, 
      String? sellerId, 
      num? type, 
      String? status, 
      String? date, 
      String? uniqueOrderId,}){
    _id = id;
    _orderId = orderId;
    _amount = amount;
    _paymentGateway = paymentGateway;
    _productId = productId;
    _sellerId = sellerId;
    _type = type;
    _status = status;
    _date = date;
    _uniqueOrderId = uniqueOrderId;
}

  SellerPendingWithdrawableAmount.fromJson(dynamic json) {
    _id = json['_id'];
    _orderId = json['orderId'];
    _amount = json['amount'];
    _paymentGateway = json['paymentGateway'];
    _productId = json['productId'] != null ? ProductId.fromJson(json['productId']) : null;
    _sellerId = json['sellerId'];
    _type = json['type'];
    _status = json['status'];
    _date = json['date'];
    _uniqueOrderId = json['uniqueOrderId'];
  }
  String? _id;
  String? _orderId;
  num? _amount;
  String? _paymentGateway;
  ProductId? _productId;
  String? _sellerId;
  num? _type;
  String? _status;
  String? _date;
  String? _uniqueOrderId;
SellerPendingWithdrawableAmount copyWith({  String? id,
  String? orderId,
  num? amount,
  String? paymentGateway,
  ProductId? productId,
  String? sellerId,
  num? type,
  String? status,
  String? date,
  String? uniqueOrderId,
}) => SellerPendingWithdrawableAmount(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  amount: amount ?? _amount,
  paymentGateway: paymentGateway ?? _paymentGateway,
  productId: productId ?? _productId,
  sellerId: sellerId ?? _sellerId,
  type: type ?? _type,
  status: status ?? _status,
  date: date ?? _date,
  uniqueOrderId: uniqueOrderId ?? _uniqueOrderId,
);
  String? get id => _id;
  String? get orderId => _orderId;
  num? get amount => _amount;
  String? get paymentGateway => _paymentGateway;
  ProductId? get productId => _productId;
  String? get sellerId => _sellerId;
  num? get type => _type;
  String? get status => _status;
  String? get date => _date;
  String? get uniqueOrderId => _uniqueOrderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderId'] = _orderId;
    map['amount'] = _amount;
    map['paymentGateway'] = _paymentGateway;
    if (_productId != null) {
      map['productId'] = _productId?.toJson();
    }
    map['sellerId'] = _sellerId;
    map['type'] = _type;
    map['status'] = _status;
    map['date'] = _date;
    map['uniqueOrderId'] = _uniqueOrderId;
    return map;
  }

}

ProductId productIdFromJson(String str) => ProductId.fromJson(json.decode(str));
String productIdToJson(ProductId data) => json.encode(data.toJson());
class ProductId {
  ProductId({
      String? id, 
      String? productName, 
      String? mainImage,}){
    _id = id;
    _productName = productName;
    _mainImage = mainImage;
}

  ProductId.fromJson(dynamic json) {
    _id = json['_id'];
    _productName = json['productName'];
    _mainImage = json['mainImage'];
  }
  String? _id;
  String? _productName;
  String? _mainImage;
ProductId copyWith({  String? id,
  String? productName,
  String? mainImage,
}) => ProductId(  id: id ?? _id,
  productName: productName ?? _productName,
  mainImage: mainImage ?? _mainImage,
);
  String? get id => _id;
  String? get productName => _productName;
  String? get mainImage => _mainImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['productName'] = _productName;
    map['mainImage'] = _mainImage;
    return map;
  }

}