import 'dart:convert';
SellerAllWalletAmountCountModel sellerAllWalletAmountCountModelFromJson(String str) => SellerAllWalletAmountCountModel.fromJson(json.decode(str));
String sellerAllWalletAmountCountModelToJson(SellerAllWalletAmountCountModel data) => json.encode(data.toJson());
class SellerAllWalletAmountCountModel {
  SellerAllWalletAmountCountModel({
      bool? status,
      String? message,
      num? pendingAmount,
      num? pendingWithdrawbleAmount,
      num? pendingWithdrawbleRequestedAmount,
      num? earningAmount,
      num? totalCommissionGiven,}){
    _status = status;
    _message = message;
    _pendingAmount = pendingAmount;
    _pendingWithdrawbleAmount = pendingWithdrawbleAmount;
    _pendingWithdrawbleRequestedAmount = pendingWithdrawbleRequestedAmount;
    _earningAmount = earningAmount;
    _totalCommissionGiven = totalCommissionGiven;
}

  SellerAllWalletAmountCountModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _pendingAmount = json['pendingAmount'];
    _pendingWithdrawbleAmount = json['pendingWithdrawbleAmount'];
    _pendingWithdrawbleRequestedAmount = json['pendingWithdrawbleRequestedAmount'];
    _earningAmount = json['earningAmount'];
    _totalCommissionGiven = json['totalCommissionGiven'];
  }
  bool? _status;
  String? _message;
  num? _pendingAmount;
  num? _pendingWithdrawbleAmount;
  num? _pendingWithdrawbleRequestedAmount;
  num? _earningAmount;
  num? _totalCommissionGiven;
SellerAllWalletAmountCountModel copyWith({  bool? status,
  String? message,
  num? pendingAmount,
  num? pendingWithdrawbleAmount,
  num? pendingWithdrawbleRequestedAmount,
  num? earningAmount,
  num? totalCommissionGiven,
}) => SellerAllWalletAmountCountModel(  status: status ?? _status,
  message: message ?? _message,
  pendingAmount: pendingAmount ?? _pendingAmount,
  pendingWithdrawbleAmount: pendingWithdrawbleAmount ?? _pendingWithdrawbleAmount,
  pendingWithdrawbleRequestedAmount: pendingWithdrawbleRequestedAmount ?? _pendingWithdrawbleRequestedAmount,
  earningAmount: earningAmount ?? _earningAmount,
  totalCommissionGiven: totalCommissionGiven ?? _totalCommissionGiven,
);
  bool? get status => _status;
  String? get message => _message;
  num? get pendingAmount => _pendingAmount;
  num? get pendingWithdrawbleAmount => _pendingWithdrawbleAmount;
  num? get pendingWithdrawbleRequestedAmount => _pendingWithdrawbleRequestedAmount;
  num? get earningAmount => _earningAmount;
  num? get totalCommissionGiven => _totalCommissionGiven;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['pendingAmount'] = _pendingAmount;
    map['pendingWithdrawbleAmount'] = _pendingWithdrawbleAmount;
    map['pendingWithdrawbleRequestedAmount'] = _pendingWithdrawbleRequestedAmount;
    map['earningAmount'] = _earningAmount;
    map['totalCommissionGiven'] = _totalCommissionGiven;
    return map;
  }

}