/// Mirror of backend Offer document, trimmed to the fields we actually read.
class OfferModel {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final num listedPrice;
  final num offerAmount;
  final num? counterAmount;
  final String? counteredBy;
  final String status; // pending | countered | accepted | declined | expired | withdrawn
  final String? orderId;
  final String buyerMessage;
  final DateTime? createdAt;

  // Optional populated nested fields from populate() on the server.
  final OfferProductSnippet? product;
  final OfferPersonSnippet? buyer;
  final OfferPersonSnippet? seller;

  OfferModel({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.listedPrice,
    required this.offerAmount,
    this.counterAmount,
    this.counteredBy,
    required this.status,
    this.orderId,
    required this.buyerMessage,
    this.createdAt,
    this.product,
    this.buyer,
    this.seller,
  });

  /// Whatever the "current proposed price" is at this moment: the seller's
  /// counter if there is one, else the buyer's original offer.
  num get activeAmount => counterAmount ?? offerAmount;

  bool get isActive => status == 'pending' || status == 'countered';
  bool get isAccepted => status == 'accepted';
  bool get awaitingBuyer => status == 'countered' && counteredBy == 'seller';

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    String pickId(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is Map && v['_id'] != null) return v['_id'].toString();
      return v.toString();
    }

    return OfferModel(
      id: json['_id']?.toString() ?? '',
      productId: pickId(json['productId']),
      buyerId: pickId(json['buyerId']),
      sellerId: pickId(json['sellerId']),
      listedPrice: (json['listedPrice'] as num?) ?? 0,
      offerAmount: (json['offerAmount'] as num?) ?? 0,
      counterAmount: json['counterAmount'] as num?,
      counteredBy: json['counteredBy']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      orderId: json['orderId']?.toString(),
      buyerMessage: json['buyerMessage']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      product: json['productId'] is Map
          ? OfferProductSnippet.fromJson(Map<String, dynamic>.from(json['productId']))
          : null,
      buyer: json['buyerId'] is Map
          ? OfferPersonSnippet.fromJson(Map<String, dynamic>.from(json['buyerId']))
          : null,
      seller: json['sellerId'] is Map
          ? OfferPersonSnippet.fromJson(Map<String, dynamic>.from(json['sellerId']))
          : null,
    );
  }
}

class OfferProductSnippet {
  final String id;
  final String productName;
  final String mainImage;
  final num price;

  OfferProductSnippet({
    required this.id,
    required this.productName,
    required this.mainImage,
    required this.price,
  });

  factory OfferProductSnippet.fromJson(Map<String, dynamic> json) => OfferProductSnippet(
        id: json['_id']?.toString() ?? '',
        productName: json['productName']?.toString() ?? '',
        mainImage: json['mainImage']?.toString() ?? '',
        price: (json['price'] as num?) ?? 0,
      );
}

class OfferPersonSnippet {
  final String id;
  final String displayName;
  final String image;

  OfferPersonSnippet({required this.id, required this.displayName, required this.image});

  factory OfferPersonSnippet.fromJson(Map<String, dynamic> json) {
    final bn = json['businessName']?.toString();
    final first = json['firstName']?.toString() ?? '';
    final last = json['lastName']?.toString() ?? '';
    final name = (bn != null && bn.isNotEmpty)
        ? bn
        : [first, last].where((e) => e.isNotEmpty).join(' ');
    return OfferPersonSnippet(
      id: json['_id']?.toString() ?? '',
      displayName: name,
      image: json['image']?.toString() ?? '',
    );
  }
}
