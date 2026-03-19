import 'dart:convert';

FetchProductInventoryModel fetchProductInventoryModelFromJson(String str) => FetchProductInventoryModel.fromJson(json.decode(str));

String fetchProductInventoryModelToJson(FetchProductInventoryModel data) => json.encode(data.toJson());

class FetchProductInventoryModel {
  bool status;
  String message;
  List<InventoryProduct> products;

  FetchProductInventoryModel({
    required this.status,
    required this.message,
    required this.products,
  });

  factory FetchProductInventoryModel.fromJson(Map<String, dynamic> json) => FetchProductInventoryModel(
        status: json["status"],
        message: json["message"],
        products: List<InventoryProduct>.from(json["products"].map((x) => InventoryProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class InventoryProduct {
  String id;
  String productCode;
  bool allowOffer;
  int minimumOfferPrice;
  int price;
  int shippingCharges;
  bool enableAuction;
  int auctionStartingPrice;
  bool enableReservePrice;
  int reservePrice;
  int auctionDuration;
  String processingTime;
  String recipientAddress;
  bool isImmediatePaymentRequired;
  String mainImage;
  List<String> images;
  List<Attribute> attributes;
  int quantity;
  int review;
  int sold;
  int searchCount;
  bool isOutOfStock;
  bool isNewCollection;
  bool isSelect;
  bool isAddByAdmin;
  bool isUpdateByAdmin;
  String createStatus;
  String updateStatus;
  String date;
  DateTime? scheduleTime;
  DateTime? auctionStartDate;
  DateTime? auctionEndDate;
  String productName;
  String description;
  Category category;
  Category subCategory;
  Seller seller;
  int productSaleType;
  DateTime createdAt;
  DateTime updatedAt;

  InventoryProduct({
    required this.id,
    required this.productCode,
    required this.allowOffer,
    required this.minimumOfferPrice,
    required this.price,
    required this.shippingCharges,
    required this.enableAuction,
    required this.auctionStartingPrice,
    required this.enableReservePrice,
    required this.reservePrice,
    required this.auctionDuration,
    required this.processingTime,
    required this.recipientAddress,
    required this.isImmediatePaymentRequired,
    required this.mainImage,
    required this.images,
    required this.attributes,
    required this.quantity,
    required this.review,
    required this.sold,
    required this.searchCount,
    required this.isOutOfStock,
    required this.isNewCollection,
    required this.isSelect,
    required this.isAddByAdmin,
    required this.isUpdateByAdmin,
    required this.createStatus,
    required this.updateStatus,
    required this.date,
    required this.scheduleTime,
    this.auctionStartDate,
    this.auctionEndDate,
    required this.productName,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.seller,
    required this.productSaleType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryProduct.fromJson(Map<String, dynamic> json) => InventoryProduct(
        id: json["_id"],
        productCode: json["productCode"],
        allowOffer: json["allowOffer"],
        minimumOfferPrice: json["minimumOfferPrice"],
        price: json["price"],
        shippingCharges: json["shippingCharges"],
        enableAuction: json["enableAuction"],
        auctionStartingPrice: json["auctionStartingPrice"],
        enableReservePrice: json["enableReservePrice"],
        reservePrice: json["reservePrice"],
        auctionDuration: json["auctionDuration"],
        processingTime: json["processingTime"] ?? "",
        recipientAddress: json["recipientAddress"] ?? "",
        isImmediatePaymentRequired: json["isImmediatePaymentRequired"],
        mainImage: json["mainImage"],
        images: List<String>.from(json["images"].map((x) => x)),
        attributes: List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
        quantity: json["quantity"],
        review: json["review"],
        sold: json["sold"],
        searchCount: json["searchCount"],
        isOutOfStock: json["isOutOfStock"],
        isNewCollection: json["isNewCollection"],
        isSelect: json["isSelect"],
        isAddByAdmin: json["isAddByAdmin"],
        isUpdateByAdmin: json["isUpdateByAdmin"],
        createStatus: json["createStatus"],
        updateStatus: json["updateStatus"],
        date: json["date"],
        scheduleTime: json["scheduleTime"] == null ? null : DateTime.parse(json["scheduleTime"]),
        auctionStartDate: json["auctionStartDate"] == null ? null : DateTime.parse(json["auctionStartDate"]),
        auctionEndDate: json["auctionEndDate"] == null ? null : DateTime.parse(json["auctionEndDate"]),
        productName: json["productName"],
        description: json["description"],
        category: Category.fromJson(json["category"]),
        subCategory: Category.fromJson(json["subCategory"]),
        seller: Seller.fromJson(json["seller"]),
        productSaleType: json["productSaleType"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productCode": productCode,
        "allowOffer": allowOffer,
        "minimumOfferPrice": minimumOfferPrice,
        "price": price,
        "shippingCharges": shippingCharges,
        "enableAuction": enableAuction,
        "auctionStartingPrice": auctionStartingPrice,
        "enableReservePrice": enableReservePrice,
        "reservePrice": reservePrice,
        "auctionDuration": auctionDuration,
        "processingTime": processingTime,
        "recipientAddress": recipientAddress,
        "isImmediatePaymentRequired": isImmediatePaymentRequired,
        "mainImage": mainImage,
        "images": List<dynamic>.from(images.map((x) => x)),
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
        "quantity": quantity,
        "review": review,
        "sold": sold,
        "searchCount": searchCount,
        "isOutOfStock": isOutOfStock,
        "isNewCollection": isNewCollection,
        "isSelect": isSelect,
        "isAddByAdmin": isAddByAdmin,
        "isUpdateByAdmin": isUpdateByAdmin,
        "createStatus": createStatus,
        "updateStatus": updateStatus,
        "date": date,
        "scheduleTime": scheduleTime?.toIso8601String(),
        "auctionStartDate": auctionStartDate?.toIso8601String(),
        "auctionEndDate": auctionEndDate?.toIso8601String(),
        "productName": productName,
        "description": description,
        "category": category.toJson(),
        "subCategory": subCategory.toJson(),
        "seller": seller.toJson(),
        "productSaleType": productSaleType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Attribute {
  String name;
  String? image;
  List<String>? values;
  int? fieldType;
  bool? isRequired;
  List<dynamic>? value;
  int? minLength;
  int? maxLength;
  bool? isActive;

  Attribute({
    required this.name,
    this.image,
    this.values,
    this.fieldType,
    this.isRequired,
    this.value,
    this.minLength,
    this.maxLength,
    this.isActive,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: json["name"],
        image: json["image"],
        values: json["values"] == null ? null : List<String>.from(json["values"]!.map((x) => x)),
        fieldType: json["fieldType"],
        isRequired: json["isRequired"],
        value: json["value"] == null ? null : List<dynamic>.from(json["value"]!.map((x) => x)),
        minLength: json["minLength"],
        maxLength: json["maxLength"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "values": values == null ? null : List<dynamic>.from(values!.map((x) => x)),
        "fieldType": fieldType,
        "isRequired": isRequired,
        "value": value == null ? null : List<dynamic>.from(value!.map((x) => x)),
        "minLength": minLength,
        "maxLength": maxLength,
        "isActive": isActive,
      };
}

class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Seller {
  String id;
  String firstName;
  String lastName;
  String businessTag;
  String businessName;
  String image;

  Seller({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.businessTag,
    required this.businessName,
    required this.image,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessTag: json["businessTag"],
        businessName: json["businessName"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "businessTag": businessTag,
        "businessName": businessName,
        "image": image,
      };
}
