// ignore_for_file: file_names
import 'dart:convert';

CreateRatingModel createRatingModelFromJson(String str) => CreateRatingModel.fromJson(json.decode(str));

String createRatingModelToJson(CreateRatingModel data) => json.encode(data.toJson());

class CreateRatingModel {
  CreateRatingModel({
    bool? status,
    String? message,
    Rating? rating,
  }) {
    _status = status;
    _message = message;
    _rating = rating;
  }

  CreateRatingModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  bool? _status;
  String? _message;
  Rating? _rating;

  CreateRatingModel copyWith({
    bool? status,
    String? message,
    Rating? rating,
  }) =>
      CreateRatingModel(
        status: status ?? _status,
        message: message ?? _message,
        rating: rating ?? _rating,
      );

  bool? get status => _status;

  String? get message => _message;

  Rating? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_rating != null) {
      map['rating'] = _rating?.toJson();
    }
    return map;
  }
}

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
  Rating({
    int? rating,
    String? id,
    String? userId,
    String? productId,
  }) {
    _rating = rating;
    _id = id;
    _userId = userId;
    _productId = productId;
  }

  Rating.fromJson(dynamic json) {
    _rating = json['rating'];
    _id = json['_id'];
    _userId = json['userId'];
    _productId = json['productId'];
  }

  int? _rating;
  String? _id;
  String? _userId;
  String? _productId;

  Rating copyWith({
    int? rating,
    String? id,
    String? userId,
    String? productId,
  }) =>
      Rating(
        rating: rating ?? _rating,
        id: id ?? _id,
        userId: userId ?? _userId,
        productId: productId ?? _productId,
      );

  int? get rating => _rating;

  String? get id => _id;

  String? get userId => _userId;

  String? get productId => _productId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rating'] = _rating;
    map['_id'] = _id;
    map['userId'] = _userId;
    map['productId'] = _productId;
    return map;
  }
}
