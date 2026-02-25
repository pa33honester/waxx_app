// To parse this JSON data, do
//
//     final liveSellerForSellingModel = liveSellerForSellingModelFromJson(jsonString);

import 'dart:convert';

import '../../seller_pages/select_product_for_streame/model/selected_product_model.dart';

LiveSellerForSellingModel liveSellerForSellingModelFromJson(String str) => LiveSellerForSellingModel.fromJson(json.decode(str));

String liveSellerForSellingModelToJson(LiveSellerForSellingModel data) => json.encode(data.toJson());

class LiveSellerForSellingModel {
  bool? status;
  String? message;
  Liveseller? liveseller;

  LiveSellerForSellingModel({
    this.status,
    this.message,
    this.liveseller,
  });

  factory LiveSellerForSellingModel.fromJson(Map<String, dynamic> json) => LiveSellerForSellingModel(
        status: json["status"],
        message: json["message"],
        liveseller: json["liveseller"] == null ? null : Liveseller.fromJson(json["liveseller"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "liveseller": liveseller?.toJson(),
      };
}

class Liveseller {
  int? agoraUid;
  String? id;
  int? view;
  String? sellerId;
  String? liveSellingHistoryId;
  List<SelectedProduct>? selectedProducts;
  int? liveType;
  String? firstName;
  String? lastName;
  String? businessName;
  String? businessTag;
  String? image;
  String? channel;
  DateTime? createdAt;
  DateTime? updatedAt;

  Liveseller({
    this.agoraUid,
    this.id,
    this.view,
    this.sellerId,
    this.liveSellingHistoryId,
    this.selectedProducts,
    this.liveType,
    this.firstName,
    this.lastName,
    this.businessName,
    this.businessTag,
    this.image,
    this.channel,
    this.createdAt,
    this.updatedAt,
  });

  factory Liveseller.fromJson(Map<String, dynamic> json) => Liveseller(
        agoraUid: json["agoraUID"],
        id: json["_id"],
        view: json["view"],
        sellerId: json["sellerId"],
        liveSellingHistoryId: json["liveSellingHistoryId"],
        selectedProducts: json["selectedProducts"] == null ? [] : List<SelectedProduct>.from(json["selectedProducts"]!.map((x) => SelectedProduct.fromJson(x))),
        liveType: json["liveType"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        businessName: json["businessName"],
        businessTag: json["businessTag"],
        image: json["image"],
        channel: json["channel"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "agoraUID": agoraUid,
        "_id": id,
        "view": view,
        "sellerId": sellerId,
        "liveSellingHistoryId": liveSellingHistoryId,
        "selectedProducts": selectedProducts == null ? [] : List<dynamic>.from(selectedProducts!.map((x) => x.toJson())),
        "liveType": liveType,
        "firstName": firstName,
        "lastName": lastName,
        "businessName": businessName,
        "businessTag": businessTag,
        "image": image,
        "channel": channel,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ProductAttribute {
  String? name;
  List<String>? values;
  String? id;

  ProductAttribute({
    this.name,
    this.values,
    this.id,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
        name: json["name"],
        values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "_id": id,
      };
}
