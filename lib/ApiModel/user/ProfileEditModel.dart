// ignore_for_file: file_names
import 'dart:convert';

/// status : true
/// message : "Success!!"

ProfileEditModel profileEditModelFromJson(String str) => ProfileEditModel.fromJson(json.decode(str));

String profileEditModelToJson(ProfileEditModel data) => json.encode(data.toJson());

class ProfileEditModel {
  ProfileEditModel({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  ProfileEditModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  bool? _status;
  String? _message;
  User? _user;

  ProfileEditModel copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      ProfileEditModel(
        status: status ?? _status,
        message: message ?? _message,
        user: user ?? _user,
      );

  bool? get status => _status;

  String? get message => _message;

  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    Notification? notification,
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? dob,
    String? gender,
    String? location,
    String? password,
    String? uniqueId,
    num? followers,
    num? following,
    num? minPrice,
    num? maxPrice,
    bool? isBlock,
    bool? isOnline,
    bool? isBusy,
    bool? isLive,
    dynamic token,
    dynamic channel,
    num? agoraUid,
    String? date,
    num? loginType,
    String? identity,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
    String? image,
  }) {
    _notification = notification;
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _dob = dob;
    _gender = gender;
    _location = location;
    _password = password;
    _uniqueId = uniqueId;
    _followers = followers;
    _following = following;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _isBlock = isBlock;
    _isOnline = isOnline;
    _isBusy = isBusy;
    _isLive = isLive;
    _token = token;
    _channel = channel;
    _agoraUid = agoraUid;
    _date = date;
    _loginType = loginType;
    _identity = identity;
    _fcmToken = fcmToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
  }

  User.fromJson(dynamic json) {
    _notification = json['notification'] != null ? Notification.fromJson(json['notification']) : null;
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _dob = json['dob'];
    _gender = json['gender'];
    _location = json['location'];
    _password = json['password'];
    _uniqueId = json['uniqueId'];
    _followers = json['followers'];
    _following = json['following'];
    _minPrice = json['minPrice'];
    _maxPrice = json['maxPrice'];
    _isBlock = json['isBlock'];
    _isOnline = json['isOnline'];
    _isBusy = json['isBusy'];
    _isLive = json['isLive'];
    _token = json['token'];
    _channel = json['channel'];
    _agoraUid = json['agoraUid'];
    _date = json['date'];
    _loginType = json['loginType'];
    _identity = json['identity'];
    _fcmToken = json['fcmToken'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _image = json['image'];
  }

  Notification? _notification;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _dob;
  String? _gender;
  String? _location;
  String? _password;
  String? _uniqueId;
  num? _followers;
  num? _following;
  num? _minPrice;
  num? _maxPrice;
  bool? _isBlock;
  bool? _isOnline;
  bool? _isBusy;
  bool? _isLive;
  dynamic _token;
  dynamic _channel;
  num? _agoraUid;
  String? _date;
  num? _loginType;
  String? _identity;
  String? _fcmToken;
  String? _createdAt;
  String? _updatedAt;
  String? _image;

  User copyWith({
    Notification? notification,
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? dob,
    String? gender,
    String? location,
    String? password,
    String? uniqueId,
    num? followers,
    num? following,
    num? minPrice,
    num? maxPrice,
    bool? isBlock,
    bool? isOnline,
    bool? isBusy,
    bool? isLive,
    dynamic token,
    dynamic channel,
    num? agoraUid,
    String? date,
    num? loginType,
    String? identity,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
    String? image,
  }) =>
      User(
        notification: notification ?? _notification,
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        dob: dob ?? _dob,
        gender: gender ?? _gender,
        location: location ?? _location,
        password: password ?? _password,
        uniqueId: uniqueId ?? _uniqueId,
        followers: followers ?? _followers,
        following: following ?? _following,
        minPrice: minPrice ?? _minPrice,
        maxPrice: maxPrice ?? _maxPrice,
        isBlock: isBlock ?? _isBlock,
        isOnline: isOnline ?? _isOnline,
        isBusy: isBusy ?? _isBusy,
        isLive: isLive ?? _isLive,
        token: token ?? _token,
        channel: channel ?? _channel,
        agoraUid: agoraUid ?? _agoraUid,
        date: date ?? _date,
        loginType: loginType ?? _loginType,
        identity: identity ?? _identity,
        fcmToken: fcmToken ?? _fcmToken,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        image: image ?? _image,
      );

  Notification? get notification => _notification;

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get email => _email;

  String? get dob => _dob;

  String? get gender => _gender;

  String? get location => _location;

  String? get password => _password;

  String? get uniqueId => _uniqueId;

  num? get followers => _followers;

  num? get following => _following;

  num? get minPrice => _minPrice;

  num? get maxPrice => _maxPrice;

  bool? get isBlock => _isBlock;

  bool? get isOnline => _isOnline;

  bool? get isBusy => _isBusy;

  bool? get isLive => _isLive;

  dynamic get token => _token;

  dynamic get channel => _channel;

  num? get agoraUid => _agoraUid;

  String? get date => _date;

  num? get loginType => _loginType;

  String? get identity => _identity;

  String? get fcmToken => _fcmToken;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_notification != null) {
      map['notification'] = _notification?.toJson();
    }
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['dob'] = _dob;
    map['gender'] = _gender;
    map['location'] = _location;
    map['password'] = _password;
    map['uniqueId'] = _uniqueId;
    map['followers'] = _followers;
    map['following'] = _following;
    map['minPrice'] = _minPrice;
    map['maxPrice'] = _maxPrice;
    map['isBlock'] = _isBlock;
    map['isOnline'] = _isOnline;
    map['isBusy'] = _isBusy;
    map['isLive'] = _isLive;
    map['token'] = _token;
    map['channel'] = _channel;
    map['agoraUid'] = _agoraUid;
    map['date'] = _date;
    map['loginType'] = _loginType;
    map['identity'] = _identity;
    map['fcmToken'] = _fcmToken;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['image'] = _image;
    return map;
  }
}

/// paymentReminder : true
/// productDelivery : true
/// message : true
/// expiredVoucher : true

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    bool? paymentReminder,
    bool? productDelivery,
    bool? message,
    bool? expiredVoucher,
  }) {
    _paymentReminder = paymentReminder;
    _productDelivery = productDelivery;
    _message = message;
    _expiredVoucher = expiredVoucher;
  }

  Notification.fromJson(dynamic json) {
    _paymentReminder = json['paymentReminder'];
    _productDelivery = json['productDelivery'];
    _message = json['message'];
    _expiredVoucher = json['expiredVoucher'];
  }

  bool? _paymentReminder;
  bool? _productDelivery;
  bool? _message;
  bool? _expiredVoucher;

  Notification copyWith({
    bool? paymentReminder,
    bool? productDelivery,
    bool? message,
    bool? expiredVoucher,
  }) =>
      Notification(
        paymentReminder: paymentReminder ?? _paymentReminder,
        productDelivery: productDelivery ?? _productDelivery,
        message: message ?? _message,
        expiredVoucher: expiredVoucher ?? _expiredVoucher,
      );

  bool? get paymentReminder => _paymentReminder;

  bool? get productDelivery => _productDelivery;

  bool? get message => _message;

  bool? get expiredVoucher => _expiredVoucher;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paymentReminder'] = _paymentReminder;
    map['productDelivery'] = _productDelivery;
    map['message'] = _message;
    map['expiredVoucher'] = _expiredVoucher;
    return map;
  }
}
