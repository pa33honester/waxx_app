import 'dart:convert';

JustForYouProductModel justForYouProductModelFromJson(String str) => JustForYouProductModel.fromJson(json.decode(str));
String justForYouProductModelToJson(JustForYouProductModel data) => json.encode(data.toJson());

class JustForYouProductModel {
  JustForYouProductModel({
    bool? status,
    String? message,
    List<JustForYouProducts>? justForYouProducts,
  }) {
    _status = status;
    _message = message;
    _justForYouProducts = justForYouProducts;
  }

  JustForYouProductModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['justForYouProducts'] != null) {
      _justForYouProducts = [];
      json['justForYouProducts'].forEach((v) {
        _justForYouProducts?.add(JustForYouProducts.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<JustForYouProducts>? _justForYouProducts;
  JustForYouProductModel copyWith({
    bool? status,
    String? message,
    List<JustForYouProducts>? justForYouProducts,
  }) =>
      JustForYouProductModel(
        status: status ?? _status,
        message: message ?? _message,
        justForYouProducts: justForYouProducts ?? _justForYouProducts,
      );
  bool? get status => _status;
  String? get message => _message;
  List<JustForYouProducts>? get justForYouProducts => _justForYouProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_justForYouProducts != null) {
      map['justForYouProducts'] = _justForYouProducts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

JustForYouProducts justForYouProductsFromJson(String str) => JustForYouProducts.fromJson(json.decode(str));
String justForYouProductsToJson(JustForYouProducts data) => json.encode(data.toJson());

class JustForYouProducts {
  JustForYouProducts({
    String? id,
    num? price,
    num? review,
    num? sold,
    String? createStatus,
    List<Attributes>? attributes,
    String? productName,
    String? mainImage,
    List<Rating>? rating,
    int? productSaleType,
    String? auctionEndDate,
  }) {
    _id = id;
    _price = price;
    _review = review;
    _sold = sold;
    _createStatus = createStatus;
    _attributes = attributes;
    _productName = productName;
    _mainImage = mainImage;
    _rating = rating;
    _productSaleType = productSaleType;
    _auctionEndDate = auctionEndDate;
  }

  JustForYouProducts.fromJson(dynamic json) {
    _id = json['_id'];
    _price = json['price'];
    _review = json['review'];
    _sold = json['sold'];
    _createStatus = json['createStatus'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
    _productName = json['productName'];
    _mainImage = json['mainImage'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating?.add(Rating.fromJson(v));
      });
    }
    _productSaleType = json['productSaleType'];
    _auctionEndDate = json['auctionEndDate'];
  }
  String? _id;
  num? _price;
  num? _review;
  num? _sold;
  String? _createStatus;
  List<Attributes>? _attributes;
  String? _productName;
  String? _mainImage;
  List<Rating>? _rating;
  int? _productSaleType;
  String? _auctionEndDate;
  JustForYouProducts copyWith({
    String? id,
    num? price,
    num? review,
    num? sold,
    String? createStatus,
    List<Attributes>? attributes,
    String? productName,
    String? mainImage,
    List<Rating>? rating,
    int? productSaleType,
    String? auctionEndDate,
  }) =>
      JustForYouProducts(
        id: id ?? _id,
        price: price ?? _price,
        review: review ?? _review,
        sold: sold ?? _sold,
        createStatus: createStatus ?? _createStatus,
        attributes: attributes ?? _attributes,
        productName: productName ?? _productName,
        mainImage: mainImage ?? _mainImage,
        rating: rating ?? _rating,
        productSaleType: productSaleType ?? _productSaleType,
        auctionEndDate: auctionEndDate ?? _auctionEndDate,
      );
  String? get id => _id;
  num? get price => _price;
  num? get review => _review;
  num? get sold => _sold;
  String? get createStatus => _createStatus;
  List<Attributes>? get attributes => _attributes;
  String? get productName => _productName;
  String? get mainImage => _mainImage;
  List<Rating>? get rating => _rating;
  int? get productSaleType => _productSaleType;
  String? get auctionEndDate => _auctionEndDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['price'] = _price;
    map['review'] = _review;
    map['sold'] = _sold;
    map['createStatus'] = _createStatus;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    map['productName'] = _productName;
    map['mainImage'] = _mainImage;
    if (_rating != null) {
      map['rating'] = _rating?.map((v) => v.toJson()).toList();
    }
    map['productSaleType'] = _productSaleType;
    map['auctionEndDate'] = _auctionEndDate;
    return map;
  }
}

Attributes attributesFromJson(String str) => Attributes.fromJson(json.decode(str));
String attributesToJson(Attributes data) => json.encode(data.toJson());

class Attributes {
  Attributes({
    String? name,
    List<String>? values,
    String? image,
  }) {
    _name = name;
    _values = values;
    _image = image;
  }

  Attributes.fromJson(dynamic json) {
    _name = json['name'];
    _values = json['values'] != null ? json['values'].cast<String>() : [];
    _image = json['image'];
  }
  String? _name;
  List<String>? _values;
  String? _image;
  Attributes copyWith({
    String? name,
    List<String>? values,
    String? image,
  }) =>
      Attributes(
        name: name ?? _name,
        values: values ?? _values,
        image: image ?? _image,
      );
  String? get name => _name;
  List<String>? get values => _values;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['values'] = _values;
    map['_image'] = _image;
    return map;
  }
}

class Rating {
  String? id;
  int? totalUser;
  int? avgRating;

  Rating({
    this.id,
    this.totalUser,
    this.avgRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["_id"],
        totalUser: json["totalUser"],
        avgRating: json["avgRating"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "totalUser": totalUser,
        "avgRating": avgRating,
      };
}
