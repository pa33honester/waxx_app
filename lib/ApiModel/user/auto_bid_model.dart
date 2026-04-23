class AutoBidModel {
  bool? status;
  String? message;
  AutoBid? data;

  AutoBidModel({this.status, this.message, this.data});

  factory AutoBidModel.fromJson(Map<String, dynamic> json) => AutoBidModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? AutoBid.fromJson(json['data']) : null,
      );
}

class AutoBid {
  String? id;
  String? userId;
  String? productId;
  num? maxBidAmount;
  num? currentBid;
  bool? isActive;

  AutoBid({this.id, this.userId, this.productId, this.maxBidAmount, this.currentBid, this.isActive});

  factory AutoBid.fromJson(Map<String, dynamic> json) => AutoBid(
        id: json['_id']?.toString(),
        userId: json['userId']?.toString(),
        productId: json['productId']?.toString(),
        maxBidAmount: json['maxBidAmount'],
        currentBid: json['currentBid'],
        isActive: json['isActive'],
      );
}
