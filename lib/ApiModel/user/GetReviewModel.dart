// ignore_for_file: file_names
import 'dart:convert';

/// status : true
/// message : "Success!!"

GetReviewModel getReviewModelFromJson(String str) => GetReviewModel.fromJson(json.decode(str));

String getReviewModelToJson(GetReviewModel data) => json.encode(data.toJson());

class GetReviewModel {
  GetReviewModel({
    bool? status,
    String? message,
    List<Reviews>? reviews,
  }) {
    _status = status;
    _message = message;
    _reviews = reviews;
  }

  GetReviewModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        _reviews?.add(Reviews.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Reviews>? _reviews;

  GetReviewModel copyWith({
    bool? status,
    String? message,
    List<Reviews>? reviews,
  }) =>
      GetReviewModel(
        status: status ?? _status,
        message: message ?? _message,
        reviews: reviews ?? _reviews,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Reviews>? get reviews => _reviews;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    String? id,
    String? review,
    String? date,
    String? createdAt,
    String? userId,
    String? firstName,
    String? lastName,
    String? userImage,
    num? rating,
    String? time,
  }) {
    _id = id;
    _review = review;
    _date = date;
    _createdAt = createdAt;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _userImage = userImage;
    _rating = rating;
    _time = time;
  }

  Reviews.fromJson(dynamic json) {
    _id = json['_id'];
    _review = json['review'];
    _date = json['date'];
    _createdAt = json['createdAt'];
    _userId = json['userId'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _userImage = json['userImage'];
    _rating = json['rating'];
    _time = json['time'];
  }

  String? _id;
  String? _review;
  String? _date;
  String? _createdAt;
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _userImage;
  num? _rating;
  String? _time;

  Reviews copyWith({
    String? id,
    String? review,
    String? date,
    String? createdAt,
    String? userId,
    String? firstName,
    String? lastName,
    String? userImage,
    num? rating,
    String? time,
  }) =>
      Reviews(
        id: id ?? _id,
        review: review ?? _review,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        userId: userId ?? _userId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        userImage: userImage ?? _userImage,
        rating: rating ?? _rating,
        time: time ?? _time,
      );

  String? get id => _id;

  String? get review => _review;

  String? get date => _date;

  String? get createdAt => _createdAt;

  String? get userId => _userId;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get userImage => _userImage;

  num? get rating => _rating;

  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['review'] = _review;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['userId'] = _userId;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['userImage'] = _userImage;
    map['rating'] = _rating;
    map['time'] = _time;
    return map;
  }
}
