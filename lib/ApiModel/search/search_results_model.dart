// Flat DTOs for the unified /search/all response. Kept intentionally thin —
// each row carries just what the tabbed search list needs to render + the
// IDs needed to deep-link to existing detail pages.

class SearchResults {
  final List<SearchProduct> products;
  final List<SearchSeller> sellers;
  final List<SearchSeller> liveShows; // same shape as seller — filtered to isLive=true
  final List<SearchReel> reels;

  const SearchResults({
    this.products = const [],
    this.sellers = const [],
    this.liveShows = const [],
    this.reels = const [],
  });

  bool get isEmpty =>
      products.isEmpty && sellers.isEmpty && liveShows.isEmpty && reels.isEmpty;

  int get total =>
      products.length + sellers.length + liveShows.length + reels.length;

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        products: (json['products'] as List? ?? const [])
            .map((e) => SearchProduct.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        sellers: (json['sellers'] as List? ?? const [])
            .map((e) => SearchSeller.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        liveShows: (json['liveShows'] as List? ?? const [])
            .map((e) => SearchSeller.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        reels: (json['reels'] as List? ?? const [])
            .map((e) => SearchReel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class SearchProduct {
  final String id;
  final String productName;
  final String mainImage;
  final num price;
  final int? productSaleType; // 1=BuyNow, 2=Auction, 3=NotForSale
  final String sellerName;
  final String sellerImage;

  const SearchProduct({
    required this.id,
    required this.productName,
    required this.mainImage,
    required this.price,
    this.productSaleType,
    this.sellerName = '',
    this.sellerImage = '',
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'] is Map ? Map<String, dynamic>.from(json['seller']) : null;
    return SearchProduct(
      id: json['_id']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      mainImage: json['mainImage']?.toString() ?? '',
      price: (json['price'] as num?) ?? 0,
      productSaleType: (json['productSaleType'] as num?)?.toInt(),
      sellerName: seller?['businessName']?.toString() ?? '',
      sellerImage: seller?['image']?.toString() ?? '',
    );
  }
}

class SearchSeller {
  final String id;
  final String businessName;
  final String businessTag;
  final String firstName;
  final String lastName;
  final String image;
  final bool isLive;
  final String? liveSellingHistoryId;
  final int followers;

  const SearchSeller({
    required this.id,
    required this.businessName,
    this.businessTag = '',
    this.firstName = '',
    this.lastName = '',
    this.image = '',
    this.isLive = false,
    this.liveSellingHistoryId,
    this.followers = 0,
  });

  String get displayName =>
      businessName.isNotEmpty ? businessName : '$firstName $lastName'.trim();

  factory SearchSeller.fromJson(Map<String, dynamic> json) => SearchSeller(
        id: json['_id']?.toString() ?? '',
        businessName: json['businessName']?.toString() ?? '',
        businessTag: json['businessTag']?.toString() ?? '',
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
        isLive: json['isLive'] == true,
        liveSellingHistoryId: json['liveSellingHistoryId']?.toString(),
        followers: (json['followers'] as num?)?.toInt() ?? 0,
      );
}

class SearchReel {
  final String id;
  final String thumbnail;
  final String video;
  final String description;
  final String sellerName;
  final String sellerImage;
  final int likes;

  const SearchReel({
    required this.id,
    required this.thumbnail,
    required this.video,
    required this.description,
    this.sellerName = '',
    this.sellerImage = '',
    this.likes = 0,
  });

  factory SearchReel.fromJson(Map<String, dynamic> json) {
    final seller = json['sellerId'] is Map ? Map<String, dynamic>.from(json['sellerId']) : null;
    return SearchReel(
      id: json['_id']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sellerName: seller?['businessName']?.toString() ?? '',
      sellerImage: seller?['image']?.toString() ?? '',
      likes: (json['like'] as num?)?.toInt() ?? 0,
    );
  }
}
