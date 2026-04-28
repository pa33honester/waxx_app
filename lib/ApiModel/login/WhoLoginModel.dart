import 'dart:convert';

WhoLoginModel whoLoginModelFromJson(String str) => WhoLoginModel.fromJson(json.decode(str));
String whoLoginModelToJson(WhoLoginModel data) => json.encode(data.toJson());

class WhoLoginModel {
  WhoLoginModel({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  WhoLoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  User? _user;
  WhoLoginModel copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      WhoLoginModel(
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
    String? country,
    String? address,
    String? mobileNumber,
    String? countryCode,
    String? image,
    String? password,
    String? seller,
    String? uniqueId,
    int? followers,
    int? following,
    bool? isSeller,
    bool? isBlock,
    String? date,
    int? loginType,
    String? identity,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
  }) {
    _notification = notification;
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _dob = dob;
    _gender = gender;
    _location = location;
    _country = country;
    _address = address;
    _mobileNumber = mobileNumber;
    _countryCode = countryCode;
    _image = image;
    _password = password;
    _seller = seller;
    _uniqueId = uniqueId;
    _followers = followers;
    _following = following;
    _isSeller = isSeller;
    _isBlock = isBlock;
    _date = date;
    _loginType = loginType;
    _identity = identity;
    _fcmToken = fcmToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
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
    _country = json['country'];
    _address = json['address'];
    _mobileNumber = json['mobileNumber'];
    _countryCode = json['countryCode'];
    _image = json['image'];
    _password = json['password'];
    _uniqueId = json['uniqueId'];
    _seller = json['seller'];
    _followers = json['followers'];
    _following = json['following'];
    _isSeller = json['isSeller'];
    _isBlock = json['isBlock'];
    _date = json['date'];
    _loginType = json['loginType'];
    _identity = json['identity'];
    _fcmToken = json['fcmToken'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  Notification? _notification;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _dob;
  String? _gender;
  String? _location;
  String? _country;
  String? _address;
  String? _mobileNumber;
  String? _countryCode;
  String? _image;
  String? _password;
  String? _seller;
  String? _uniqueId;
  int? _followers;
  int? _following;
  bool? _isSeller;
  bool? _isBlock;
  String? _date;
  int? _loginType;
  String? _identity;
  String? _fcmToken;
  String? _createdAt;
  String? _updatedAt;
  User copyWith({
    Notification? notification,
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? dob,
    String? gender,
    String? location,
    String? country,
    String? address,
    String? mobileNumber,
    String? countryCode,
    String? image,
    String? password,
    String? seller,
    String? uniqueId,
    int? followers,
    int? following,
    bool? isSeller,
    bool? isBlock,
    String? date,
    int? loginType,
    String? identity,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
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
        country: country ?? _country,
        address: address ?? _address,
        mobileNumber: mobileNumber ?? _mobileNumber,
        countryCode: mobileNumber ?? _countryCode,
        image: image ?? _image,
        password: password ?? _password,
        seller: seller ?? _seller,
        uniqueId: uniqueId ?? _uniqueId,
        followers: followers ?? _followers,
        following: following ?? _following,
        isSeller: isSeller ?? _isSeller,
        isBlock: isBlock ?? _isBlock,
        date: date ?? _date,
        loginType: loginType ?? _loginType,
        identity: identity ?? _identity,
        fcmToken: fcmToken ?? _fcmToken,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  Notification? get notification => _notification;
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get dob => _dob;
  String? get gender => _gender;
  String? get location => _location;
  String? get country => _country;
  String? get address => _address;
  String? get mobileNumber => _mobileNumber;
  String? get countryCode => _countryCode;
  String? get image => _image;
  String? get password => _password;
  String? get seller => _seller;
  String? get uniqueId => _uniqueId;
  int? get followers => _followers;
  int? get following => _following;
  bool? get isSeller => _isSeller;
  bool? get isBlock => _isBlock;
  String? get date => _date;
  int? get loginType => _loginType;
  String? get identity => _identity;
  String? get fcmToken => _fcmToken;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

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
    map['country'] = _country;
    map['address'] = _address;
    map['mobileNumber'] = _mobileNumber;
    map['countryCode'] = _countryCode;
    map['image'] = _image;
    map['password'] = _password;
    map['seller'] = _seller;
    map['uniqueId'] = _uniqueId;
    map['followers'] = _followers;
    map['following'] = _following;
    map['isSeller'] = _isSeller;
    map['isBlock'] = _isBlock;
    map['date'] = _date;
    map['loginType'] = _loginType;
    map['identity'] = _identity;
    map['fcmToken'] = _fcmToken;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));
String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    bool? paymentReminder,
    bool? productDelivery,
    bool? expiredVoucher,
  }) {
    _paymentReminder = paymentReminder;
    _productDelivery = productDelivery;
    _expiredVoucher = expiredVoucher;
  }

  Notification.fromJson(dynamic json) {
    _paymentReminder = json['paymentReminder'];
    _productDelivery = json['productDelivery'];
    _expiredVoucher = json['expiredVoucher'];
  }
  bool? _paymentReminder;
  bool? _productDelivery;
  bool? _expiredVoucher;
  Notification copyWith({
    bool? paymentReminder,
    bool? productDelivery,
    bool? expiredVoucher,
  }) =>
      Notification(
        paymentReminder: paymentReminder ?? _paymentReminder,
        productDelivery: productDelivery ?? _productDelivery,
        expiredVoucher: expiredVoucher ?? _expiredVoucher,
      );
  bool? get paymentReminder => _paymentReminder;
  bool? get productDelivery => _productDelivery;
  bool? get expiredVoucher => _expiredVoucher;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paymentReminder'] = _paymentReminder;
    map['productDelivery'] = _productDelivery;
    map['expiredVoucher'] = _expiredVoucher;
    return map;
  }
}
