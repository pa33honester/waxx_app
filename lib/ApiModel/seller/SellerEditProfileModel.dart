// ignore_for_file: file_names
import 'dart:convert';

SellerEditProfileModel sellerEditProfileModelFromJson(String str) =>
    SellerEditProfileModel.fromJson(json.decode(str));

String sellerEditProfileModelToJson(SellerEditProfileModel data) => json.encode(data.toJson());

class SellerEditProfileModel {
  SellerEditProfileModel({
    bool? status,
    String? message,
    Seller? seller,
  }) {
    _status = status;
    _message = message;
    _seller = seller;
  }

  SellerEditProfileModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
  }

  bool? _status;
  String? _message;
  Seller? _seller;

  SellerEditProfileModel copyWith({
    bool? status,
    String? message,
    Seller? seller,
  }) =>
      SellerEditProfileModel(
        status: status ?? _status,
        message: message ?? _message,
        seller: seller ?? _seller,
      );

  bool? get status => _status;

  String? get message => _message;

  Seller? get seller => _seller;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    return map;
  }
}

Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));

String sellerToJson(Seller data) => json.encode(data.toJson());

class Seller {
  Seller({
    Address? address,
    BankDetails? bankDetails,
    String? id,
    String? firstName,
    String? lastName,
    String? businessTag,
    String? businessName,
    String? email,
    String? mobileNumber,
    String? gender,
    String? image,
    num? followers,
    num? following,
    String? uniqueId,
    String? password,
    dynamic token,
    dynamic channel,
    num? agoraUid,
    bool? isOnline,
    bool? isBlock,
    bool? isBusy,
    bool? isLive,
    bool? isSeller,
    String? identity,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) {
    _address = address;
    _bankDetails = bankDetails;
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _businessTag = businessTag;
    _businessName = businessName;
    _email = email;
    _mobileNumber = mobileNumber;
    _gender = gender;
    _image = image;
    _followers = followers;
    _following = following;
    _uniqueId = uniqueId;
    _password = password;
    _token = token;
    _channel = channel;
    _agoraUid = agoraUid;
    _isOnline = isOnline;
    _isBlock = isBlock;
    _isBusy = isBusy;
    _isLive = isLive;
    _isSeller = isSeller;
    _identity = identity;
    _date = date;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Seller.fromJson(dynamic json) {
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
    _bankDetails = json['bankDetails'] != null ? BankDetails.fromJson(json['bankDetails']) : null;
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _businessTag = json['businessTag'];
    _businessName = json['businessName'];
    _email = json['email'];
    _mobileNumber = json['mobileNumber'];
    _gender = json['gender'];
    _image = json['image'];
    _followers = json['followers'];
    _following = json['following'];
    _uniqueId = json['uniqueId'];
    _password = json['password'];
    _token = json['token'];
    _channel = json['channel'];
    _agoraUid = json['agoraUid'];
    _isOnline = json['isOnline'];
    _isBlock = json['isBlock'];
    _isBusy = json['isBusy'];
    _isLive = json['isLive'];
    _isSeller = json['isSeller'];
    _identity = json['identity'];
    _date = json['date'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Address? _address;
  BankDetails? _bankDetails;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _businessTag;
  String? _businessName;
  String? _email;
  String? _mobileNumber;
  String? _gender;
  String? _image;
  num? _followers;
  num? _following;
  String? _uniqueId;
  String? _password;
  dynamic _token;
  dynamic _channel;
  num? _agoraUid;
  bool? _isOnline;
  bool? _isBlock;
  bool? _isBusy;
  bool? _isLive;
  bool? _isSeller;
  String? _identity;
  String? _date;
  String? _createdAt;
  String? _updatedAt;

  Seller copyWith({
    Address? address,
    BankDetails? bankDetails,
    String? id,
    String? firstName,
    String? lastName,
    String? businessTag,
    String? businessName,
    String? email,
    String? mobileNumber,
    String? gender,
    String? image,
    num? followers,
    num? following,
    String? uniqueId,
    String? password,
    dynamic token,
    dynamic channel,
    num? agoraUid,
    bool? isOnline,
    bool? isBlock,
    bool? isBusy,
    bool? isLive,
    bool? isSeller,
    String? identity,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) =>
      Seller(
        address: address ?? _address,
        bankDetails: bankDetails ?? _bankDetails,
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        businessTag: businessTag ?? _businessTag,
        businessName: businessName ?? _businessName,
        email: email ?? _email,
        mobileNumber: mobileNumber ?? _mobileNumber,
        gender: gender ?? _gender,
        image: image ?? _image,
        followers: followers ?? _followers,
        following: following ?? _following,
        uniqueId: uniqueId ?? _uniqueId,
        password: password ?? _password,
        token: token ?? _token,
        channel: channel ?? _channel,
        agoraUid: agoraUid ?? _agoraUid,
        isOnline: isOnline ?? _isOnline,
        isBlock: isBlock ?? _isBlock,
        isBusy: isBusy ?? _isBusy,
        isLive: isLive ?? _isLive,
        isSeller: isSeller ?? _isSeller,
        identity: identity ?? _identity,
        date: date ?? _date,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  Address? get address => _address;

  BankDetails? get bankDetails => _bankDetails;

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get businessTag => _businessTag;

  String? get businessName => _businessName;

  String? get email => _email;

  String? get mobileNumber => _mobileNumber;

  String? get gender => _gender;

  String? get image => _image;

  num? get followers => _followers;

  num? get following => _following;

  String? get uniqueId => _uniqueId;

  String? get password => _password;

  dynamic get token => _token;

  dynamic get channel => _channel;

  num? get agoraUid => _agoraUid;

  bool? get isOnline => _isOnline;

  bool? get isBlock => _isBlock;

  bool? get isBusy => _isBusy;

  bool? get isLive => _isLive;

  bool? get isSeller => _isSeller;

  String? get identity => _identity;

  String? get date => _date;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    if (_bankDetails != null) {
      map['bankDetails'] = _bankDetails?.toJson();
    }
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['businessTag'] = _businessTag;
    map['businessName'] = _businessName;
    map['email'] = _email;
    map['mobileNumber'] = _mobileNumber;
    map['gender'] = _gender;
    map['image'] = _image;
    map['followers'] = _followers;
    map['following'] = _following;
    map['uniqueId'] = _uniqueId;
    map['password'] = _password;
    map['token'] = _token;
    map['channel'] = _channel;
    map['agoraUid'] = _agoraUid;
    map['isOnline'] = _isOnline;
    map['isBlock'] = _isBlock;
    map['isBusy'] = _isBusy;
    map['isLive'] = _isLive;
    map['isSeller'] = _isSeller;
    map['identity'] = _identity;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

/// bankBusinessName : "hello"
/// bankName : "kotak first bank"
/// accountNumber : 968946097678645
/// IFSCCode : "IFSC code "
/// branchName : "Branchhhh"

BankDetails bankDetailsFromJson(String str) => BankDetails.fromJson(json.decode(str));

String bankDetailsToJson(BankDetails data) => json.encode(data.toJson());

class BankDetails {
  BankDetails({
    String? bankBusinessName,
    String? bankName,
    num? accountNumber,
    String? iFSCCode,
    String? branchName,
  }) {
    _bankBusinessName = bankBusinessName;
    _bankName = bankName;
    _accountNumber = accountNumber;
    _iFSCCode = iFSCCode;
    _branchName = branchName;
  }

  BankDetails.fromJson(dynamic json) {
    _bankBusinessName = json['bankBusinessName'];
    _bankName = json['bankName'];
    _accountNumber = json['accountNumber'];
    _iFSCCode = json['IFSCCode'];
    _branchName = json['branchName'];
  }

  String? _bankBusinessName;
  String? _bankName;
  num? _accountNumber;
  String? _iFSCCode;
  String? _branchName;

  BankDetails copyWith({
    String? bankBusinessName,
    String? bankName,
    num? accountNumber,
    String? iFSCCode,
    String? branchName,
  }) =>
      BankDetails(
        bankBusinessName: bankBusinessName ?? _bankBusinessName,
        bankName: bankName ?? _bankName,
        accountNumber: accountNumber ?? _accountNumber,
        iFSCCode: iFSCCode ?? _iFSCCode,
        branchName: branchName ?? _branchName,
      );

  String? get bankBusinessName => _bankBusinessName;

  String? get bankName => _bankName;

  num? get accountNumber => _accountNumber;

  String? get iFSCCode => _iFSCCode;

  String? get branchName => _branchName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bankBusinessName'] = _bankBusinessName;
    map['bankName'] = _bankName;
    map['accountNumber'] = _accountNumber;
    map['IFSCCode'] = _iFSCCode;
    map['branchName'] = _branchName;
    return map;
  }
}

/// address : "yogi chowlk"
/// landMark : "polllll"
/// city : "surat"
/// pinCode : 6966969
/// state : "Surat"
/// country : "Germany"

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    String? address,
    String? landMark,
    String? city,
    num? pinCode,
    String? state,
    String? country,
  }) {
    _address = address;
    _landMark = landMark;
    _city = city;
    _pinCode = pinCode;
    _state = state;
    _country = country;
  }

  Address.fromJson(dynamic json) {
    _address = json['address'];
    _landMark = json['landMark'];
    _city = json['city'];
    _pinCode = json['pinCode'];
    _state = json['state'];
    _country = json['country'];
  }

  String? _address;
  String? _landMark;
  String? _city;
  num? _pinCode;
  String? _state;
  String? _country;

  Address copyWith({
    String? address,
    String? landMark,
    String? city,
    num? pinCode,
    String? state,
    String? country,
  }) =>
      Address(
        address: address ?? _address,
        landMark: landMark ?? _landMark,
        city: city ?? _city,
        pinCode: pinCode ?? _pinCode,
        state: state ?? _state,
        country: country ?? _country,
      );

  String? get address => _address;

  String? get landMark => _landMark;

  String? get city => _city;

  num? get pinCode => _pinCode;

  String? get state => _state;

  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['landMark'] = _landMark;
    map['city'] = _city;
    map['pinCode'] = _pinCode;
    map['state'] = _state;
    map['country'] = _country;
    return map;
  }
}
