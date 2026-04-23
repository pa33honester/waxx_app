class GiveawayModel {
  final String id;
  final String sellerId;
  final String liveSellingHistoryId;
  final String productId;
  final String productName;
  final String mainImage;
  final int type; // 1 = standard, 2 = followerOnly
  final int status; // 1 open, 2 closed, 3 drawn, 4 cancelled
  final int entryWindowSeconds;
  final DateTime startedAt;
  final DateTime closesAt;
  final int entryCount;
  final String? winnerUserId;
  final String? winnerFirstName;
  final String? winnerLastName;
  final String? winnerImage;
  final DateTime? winnerDrawnAt;
  final String? orderId;

  GiveawayModel({
    required this.id,
    required this.sellerId,
    required this.liveSellingHistoryId,
    required this.productId,
    required this.productName,
    required this.mainImage,
    required this.type,
    required this.status,
    required this.entryWindowSeconds,
    required this.startedAt,
    required this.closesAt,
    required this.entryCount,
    this.winnerUserId,
    this.winnerFirstName,
    this.winnerLastName,
    this.winnerImage,
    this.winnerDrawnAt,
    this.orderId,
  });

  factory GiveawayModel.fromStartedEvent(Map<String, dynamic> json) {
    return GiveawayModel(
      id: json['giveawayId']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      liveSellingHistoryId: json['liveSellingHistoryId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      mainImage: json['mainImage']?.toString() ?? '',
      type: (json['type'] as num?)?.toInt() ?? 1,
      status: 1,
      entryWindowSeconds: (json['entryWindowSeconds'] as num?)?.toInt() ?? 60,
      startedAt: DateTime.tryParse(json['startedAt']?.toString() ?? '') ?? DateTime.now(),
      closesAt: DateTime.tryParse(json['closesAt']?.toString() ?? '') ?? DateTime.now().add(const Duration(seconds: 60)),
      entryCount: 0,
    );
  }

  factory GiveawayModel.fromApi(Map<String, dynamic> json) {
    final productMap = json['productId'] is Map ? json['productId'] as Map<String, dynamic> : null;
    final winnerMap = json['winnerUserId'] is Map ? json['winnerUserId'] as Map<String, dynamic> : null;

    return GiveawayModel(
      id: json['_id']?.toString() ?? json['giveawayId']?.toString() ?? '',
      sellerId: (json['sellerId'] is Map
              ? (json['sellerId'] as Map)['_id']
              : json['sellerId'])
          ?.toString() ??
          '',
      liveSellingHistoryId: json['liveSellingHistoryId']?.toString() ?? '',
      productId: (productMap?['_id'] ?? json['productId'])?.toString() ?? '',
      productName: (productMap?['productName'] ?? json['productName'] ?? '').toString(),
      mainImage: (productMap?['mainImage'] ?? json['mainImage'] ?? '').toString(),
      type: (json['type'] as num?)?.toInt() ?? 1,
      status: (json['status'] as num?)?.toInt() ?? 1,
      entryWindowSeconds: (json['entryWindowSeconds'] as num?)?.toInt() ?? 60,
      startedAt: DateTime.tryParse(json['startedAt']?.toString() ?? '') ?? DateTime.now(),
      closesAt: DateTime.tryParse(json['closesAt']?.toString() ?? '') ?? DateTime.now(),
      entryCount: (json['entryCount'] as num?)?.toInt() ?? 0,
      winnerUserId: (winnerMap?['_id'] ?? json['winnerUserId'])?.toString(),
      winnerFirstName: winnerMap?['firstName']?.toString(),
      winnerLastName: winnerMap?['lastName']?.toString(),
      winnerImage: winnerMap?['image']?.toString(),
      winnerDrawnAt: DateTime.tryParse(json['winnerDrawnAt']?.toString() ?? ''),
      orderId: json['winnerOrderId']?.toString() ?? json['orderId']?.toString(),
    );
  }

  GiveawayModel copyWith({
    int? entryCount,
    int? status,
    String? winnerUserId,
    String? winnerFirstName,
    String? winnerLastName,
    String? winnerImage,
    DateTime? winnerDrawnAt,
    String? orderId,
  }) {
    return GiveawayModel(
      id: id,
      sellerId: sellerId,
      liveSellingHistoryId: liveSellingHistoryId,
      productId: productId,
      productName: productName,
      mainImage: mainImage,
      type: type,
      status: status ?? this.status,
      entryWindowSeconds: entryWindowSeconds,
      startedAt: startedAt,
      closesAt: closesAt,
      entryCount: entryCount ?? this.entryCount,
      winnerUserId: winnerUserId ?? this.winnerUserId,
      winnerFirstName: winnerFirstName ?? this.winnerFirstName,
      winnerLastName: winnerLastName ?? this.winnerLastName,
      winnerImage: winnerImage ?? this.winnerImage,
      winnerDrawnAt: winnerDrawnAt ?? this.winnerDrawnAt,
      orderId: orderId ?? this.orderId,
    );
  }
}

class GiveawayWinnerEvent {
  final String giveawayId;
  final String winnerId;
  final String firstName;
  final String lastName;
  final String image;
  final String productId;
  final String productName;
  final String mainImage;
  final String? orderId;

  GiveawayWinnerEvent({
    required this.giveawayId,
    required this.winnerId,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.productId,
    required this.productName,
    required this.mainImage,
    this.orderId,
  });

  factory GiveawayWinnerEvent.fromJson(Map<String, dynamic> json) {
    return GiveawayWinnerEvent(
      giveawayId: json['giveawayId']?.toString() ?? '',
      winnerId: json['winnerId']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      mainImage: json['mainImage']?.toString() ?? '',
      orderId: json['orderId']?.toString(),
    );
  }
}
