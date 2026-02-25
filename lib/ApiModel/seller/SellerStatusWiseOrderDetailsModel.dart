class SellerStatusWiseOrderDetailsModel {
  bool? status;
  String? message;
  List<Orders>? orders;

  SellerStatusWiseOrderDetailsModel({this.status, this.message, this.orders});

  SellerStatusWiseOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? id;
  List<Items>? items;
  ShippingAddress? shippingAddress;
  String? orderId;
  String? createdAt;
  String? userFirstName;
  String? userLastName;
  String? paymentGateway;
  int? paymentStatus;
  String? userMobileNumber;
  String? userId;

  Orders({
    this.id,
    this.items,
    this.shippingAddress,
    this.orderId,
    this.createdAt,
    this.userFirstName,
    this.userLastName,
    this.paymentGateway,
    this.paymentStatus,
    this.userMobileNumber,
    this.userId,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    shippingAddress = json['shippingAddress'] != null ? new ShippingAddress.fromJson(json['shippingAddress']) : null;
    orderId = json['orderId'];
    createdAt = json['createdAt'];
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
    paymentGateway = json['paymentGateway'];
    paymentStatus = json['paymentStatus'];
    userMobileNumber = json['userMobileNumber'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    data['orderId'] = orderId;
    data['createdAt'] = createdAt;
    data['userFirstName'] = userFirstName;
    data['userLastName'] = userLastName;
    data['paymentGateway'] = paymentGateway;
    data['paymentStatus'] = paymentStatus;
    data['userMobileNumber'] = userMobileNumber;
    data['userId'] = userId;
    return data;
  }
}

class Items {
  ProductId? productId;
  String? sellerId;
  int? purchasedTimeProductPrice;
  int? purchasedTimeShippingCharges;
  String? productCode;
  int? productQuantity;
  List<AttributesArray>? attributesArray;
  num? commissionPerProductQuantity;
  num? itemDiscountRate;
  num? itemDiscount;
  String? status;
  String? deliveredServiceName;
  String? trackingId;
  String? trackingLink;
  String? date;
  String? id;
  String? analyticDate;

  Items(
      {this.productId,
      this.sellerId,
      this.purchasedTimeProductPrice,
      this.purchasedTimeShippingCharges,
      this.productCode,
      this.productQuantity,
      this.attributesArray,
      this.commissionPerProductQuantity,
      this.itemDiscountRate,
      this.itemDiscount,
      this.status,
      this.deliveredServiceName,
      this.trackingId,
      this.trackingLink,
      this.date,
      this.id,
      this.analyticDate});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] != null ? new ProductId.fromJson(json['productId']) : null;
    sellerId = json['sellerId'];
    purchasedTimeProductPrice = json['purchasedTimeProductPrice'];
    purchasedTimeShippingCharges = json['purchasedTimeShippingCharges'];
    productCode = json['productCode'];
    productQuantity = json['productQuantity'];
    if (json['attributesArray'] != null) {
      attributesArray = <AttributesArray>[];
      json['attributesArray'].forEach((v) {
        attributesArray!.add(new AttributesArray.fromJson(v));
      });
    }
    commissionPerProductQuantity = json['commissionPerProductQuantity'];
    itemDiscountRate = json['itemDiscountRate'];
    itemDiscount = json['itemDiscount'];
    status = json['status'];
    deliveredServiceName = json['deliveredServiceName'];
    trackingId = json['trackingId'];
    trackingLink = json['trackingLink'];
    date = json['date'];
    id = json['_id'];
    analyticDate = json['analyticDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (productId != null) {
      data['productId'] = productId!.toJson();
    }
    data['sellerId'] = sellerId;
    data['purchasedTimeProductPrice'] = purchasedTimeProductPrice;
    data['purchasedTimeShippingCharges'] = purchasedTimeShippingCharges;
    data['productCode'] = productCode;
    data['productQuantity'] = productQuantity;
    if (attributesArray != null) {
      data['attributesArray'] = attributesArray!.map((v) => v.toJson()).toList();
    }
    data['commissionPerProductQuantity'] = commissionPerProductQuantity;
    data['itemDiscountRate'] = itemDiscountRate;
    data['itemDiscount'] = itemDiscount;
    data['status'] = status;
    data['deliveredServiceName'] = deliveredServiceName;
    data['trackingId'] = trackingId;
    data['trackingLink'] = trackingLink;
    data['date'] = date;
    data['_id'] = id;
    data['analyticDate'] = analyticDate;
    return data;
  }
}

class ProductId {
  String? id;
  String? productName;
  String? mainImage;

  ProductId({this.id, this.productName, this.mainImage});

  ProductId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['productName'];
    mainImage = json['mainImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['productName'] = productName;
    data['mainImage'] = mainImage;
    return data;
  }
}

class AttributesArray {
  String? name;
  List<String>? values;
  String? image;

  AttributesArray({
    this.name,
    this.values,
    this.image,
  });

  factory AttributesArray.fromJson(Map<String, dynamic> json) => AttributesArray(
        name: json["name"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "image": image,
      };
}

class ShippingAddress {
  String? name;
  String? country;
  String? state;
  String? city;
  int? zipCode;
  String? address;

  ShippingAddress({this.name, this.country, this.state, this.city, this.zipCode, this.address});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zipCode'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['zipCode'] = zipCode;
    data['address'] = address;
    return data;
  }
}
