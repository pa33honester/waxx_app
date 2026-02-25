// ignore_for_file: file_names
import 'dart:convert';

SellerMyOrderCountModel sellerMyOrderCountModelFromJson(String str) =>
    SellerMyOrderCountModel.fromJson(json.decode(str));

String sellerMyOrderCountModelToJson(SellerMyOrderCountModel data) => json.encode(data.toJson());

class SellerMyOrderCountModel {
  SellerMyOrderCountModel({
    bool? status,
    String? message,
    int? totalOrders,
    int? pendingOrders,
    int? confirmedOrders,
    int? outOfDeliveryOrders,
    int? deliveredOrders,
    int? cancelledOrders,
  }) {
    _status = status;
    _message = message;
    _totalOrders = totalOrders;
    _pendingOrders = pendingOrders;
    _confirmedOrders = confirmedOrders;
    _outOfDeliveryOrders = outOfDeliveryOrders;
    _deliveredOrders = deliveredOrders;
    _cancelledOrders = cancelledOrders;
  }

  SellerMyOrderCountModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _totalOrders = json['totalOrders'];
    _pendingOrders = json['pendingOrders'];
    _confirmedOrders = json['confirmedOrders'];
    _outOfDeliveryOrders = json['outOfDeliveryOrders'];
    _deliveredOrders = json['deliveredOrders'];
    _cancelledOrders = json['cancelledOrders'];
  }

  bool? _status;
  String? _message;
  int? _totalOrders;
  int? _pendingOrders;
  int? _confirmedOrders;
  int? _outOfDeliveryOrders;
  int? _deliveredOrders;
  int? _cancelledOrders;

  SellerMyOrderCountModel copyWith({
    bool? status,
    String? message,
    int? totalOrders,
    int? pendingOrders,
    int? confirmedOrders,
    int? outOfDeliveryOrders,
    int? deliveredOrders,
    int? cancelledOrders,
  }) =>
      SellerMyOrderCountModel(
        status: status ?? _status,
        message: message ?? _message,
        totalOrders: totalOrders ?? _totalOrders,
        pendingOrders: pendingOrders ?? _pendingOrders,
        confirmedOrders: confirmedOrders ?? _confirmedOrders,
        outOfDeliveryOrders: outOfDeliveryOrders ?? _outOfDeliveryOrders,
        deliveredOrders: deliveredOrders ?? _deliveredOrders,
        cancelledOrders: cancelledOrders ?? _cancelledOrders,
      );

  bool? get status => _status;

  String? get message => _message;

  int? get totalOrders => _totalOrders;

  int? get pendingOrders => _pendingOrders;

  int? get confirmedOrders => _confirmedOrders;

  int? get outOfDeliveryOrders => _outOfDeliveryOrders;

  int? get deliveredOrders => _deliveredOrders;

  int? get cancelledOrders => _cancelledOrders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['totalOrders'] = _totalOrders;
    map['pendingOrders'] = _pendingOrders;
    map['confirmedOrders'] = _confirmedOrders;
    map['outOfDeliveryOrders'] = _outOfDeliveryOrders;
    map['deliveredOrders'] = _deliveredOrders;
    map['cancelledOrders'] = _cancelledOrders;
    return map;
  }
}
