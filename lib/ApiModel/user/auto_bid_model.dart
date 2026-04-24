class AutoBidModel {
  bool? status;
  String? message;
  AutoBid? data;
  num? minAcceptable; // populated when setAutoBid rejects for too-low max

  AutoBidModel({this.status, this.message, this.data, this.minAcceptable});

  factory AutoBidModel.fromJson(Map<String, dynamic> json) => AutoBidModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null
            ? (json['data'] is Map
                ? AutoBid.fromJson(Map<String, dynamic>.from(json['data']))
                : null)
            : null,
        minAcceptable: json['minAcceptable'] as num?,
      );
}

class AutoBid {
  String? id;
  String? userId;
  String? productId;
  String? liveHistoryId;
  num? maxBidAmount;
  num? currentBid;
  bool? isActive;

  AutoBid({
    this.id,
    this.userId,
    this.productId,
    this.liveHistoryId,
    this.maxBidAmount,
    this.currentBid,
    this.isActive,
  });

  factory AutoBid.fromJson(Map<String, dynamic> json) => AutoBid(
        id: json['_id']?.toString(),
        userId: json['userId']?.toString(),
        productId: json['productId']?.toString(),
        liveHistoryId: json['liveHistoryId']?.toString(),
        maxBidAmount: json['maxBidAmount'] as num?,
        currentBid: json['currentBid'] as num?,
        isActive: json['isActive'] as bool?,
      );
}
