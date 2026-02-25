// ignore_for_file: file_names
import 'dart:convert';

CreateReviewModel createReviewModelFromJson(String str) => CreateReviewModel.fromJson(json.decode(str));

String createReviewModelToJson(CreateReviewModel data) => json.encode(data.toJson());

class CreateReviewModel {
  CreateReviewModel({
    bool? status,
    String? message,
    Review? review,
  }) {
    _status = status;
    _message = message;
    _review = review;
  }

  CreateReviewModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _review = json['review'] != null ? Review.fromJson(json['review']) : null;
  }

  bool? _status;
  String? _message;
  Review? _review;

  CreateReviewModel copyWith({
    bool? status,
    String? message,
    Review? review,
  }) =>
      CreateReviewModel(
        status: status ?? _status,
        message: message ?? _message,
        review: review ?? _review,
      );

  bool? get status => _status;

  String? get message => _message;

  Review? get review => _review;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_review != null) {
      map['review'] = _review?.toJson();
    }
    return map;
  }
}

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  Review({
    String? id,
    String? userId,
    String? productId,
    String? review,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _productId = productId;
    _review = review;
    _date = date;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Review.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['userId'];
    _productId = json['productId'];
    _review = json['review'];
    _date = json['date'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _userId;
  String? _productId;
  String? _review;
  String? _date;
  String? _createdAt;
  String? _updatedAt;

  Review copyWith({
    String? id,
    String? userId,
    String? productId,
    String? review,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) =>
      Review(
        id: id ?? _id,
        userId: userId ?? _userId,
        productId: productId ?? _productId,
        review: review ?? _review,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get userId => _userId;

  String? get productId => _productId;

  String? get review => _review;

  String? get date => _date;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['userId'] = _userId;
    map['productId'] = _productId;
    map['review'] = _review;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
