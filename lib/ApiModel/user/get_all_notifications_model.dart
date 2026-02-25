import 'dart:convert';

GetAllNotificationsModel getAllNotificationsModelFromJson(String str) =>
    GetAllNotificationsModel.fromJson(json.decode(str));

String getAllNotificationsModelToJson(GetAllNotificationsModel data) => json.encode(data.toJson());

class GetAllNotificationsModel {
  GetAllNotificationsModel({
    bool? status,
    String? message,
    List<Notification>? notification,
  }) {
    _status = status;
    _message = message;
    _notification = notification;
  }

  GetAllNotificationsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['notification'] != null) {
      _notification = [];
      json['notification'].forEach((v) {
        _notification?.add(Notification.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Notification>? _notification;

  GetAllNotificationsModel copyWith({
    bool? status,
    String? message,
    List<Notification>? notification,
  }) =>
      GetAllNotificationsModel(
        status: status ?? _status,
        message: message ?? _message,
        notification: notification ?? _notification,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Notification>? get notification => _notification;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_notification != null) {
      map['notification'] = _notification?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    String? id,
    String? title,
    String? message,
    String? image,
    String? date,
    String? userId,
    dynamic sellerId,
    dynamic productId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _message = message;
    _image = image;
    _date = date;
    _userId = userId;
    _sellerId = sellerId;
    _productId = productId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Notification.fromJson(dynamic json) {
    _id = json['_id'];
    _title = json['title'];
    _message = json['message'];
    _image = json['image'];
    _date = json['date'];
    _userId = json['userId'];
    _sellerId = json['sellerId'];
    _productId = json['productId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _title;
  String? _message;
  String? _image;
  String? _date;
  String? _userId;
  dynamic _sellerId;
  dynamic _productId;
  String? _createdAt;
  String? _updatedAt;

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? image,
    String? date,
    String? userId,
    dynamic sellerId,
    dynamic productId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Notification(
        id: id ?? _id,
        title: title ?? _title,
        message: message ?? _message,
        image: image ?? _image,
        date: date ?? _date,
        userId: userId ?? _userId,
        sellerId: sellerId ?? _sellerId,
        productId: productId ?? _productId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get title => _title;

  String? get message => _message;

  String? get image => _image;

  String? get date => _date;

  String? get userId => _userId;

  dynamic get sellerId => _sellerId;

  dynamic get productId => _productId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['title'] = _title;
    map['message'] = _message;
    map['image'] = _image;
    map['date'] = _date;
    map['userId'] = _userId;
    map['sellerId'] = _sellerId;
    map['productId'] = _productId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
