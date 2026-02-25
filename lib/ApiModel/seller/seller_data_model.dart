// import 'dart:convert';
//
// SellerDataModel sellerDataModelFromJson(String str) => SellerDataModel.fromJson(json.decode(str));
//
// String sellerDataModelToJson(SellerDataModel data) => json.encode(data.toJson());
//
// class SellerDataModel {
//   SellerDataModel({
//     bool? status,
//     String? message,
//     Seller? seller,
//     bool? isAccepted,
//   }) {
//     _status = status;
//     _message = message;
//     _seller = seller;
//     _isAccepted = isAccepted;
//   }
//
//   SellerDataModel.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
//     _isAccepted = json['isAccepted'];
//   }
//
//   bool? _status;
//   String? _message;
//   Seller? _seller;
//   bool? _isAccepted;
//
//   SellerDataModel copyWith({
//     bool? status,
//     String? message,
//     Seller? seller,
//     bool? isAccepted,
//   }) =>
//       SellerDataModel(
//         status: status ?? _status,
//         message: message ?? _message,
//         seller: seller ?? _seller,
//         isAccepted: isAccepted ?? _isAccepted,
//       );
//
//   bool? get status => _status;
//
//   String? get message => _message;
//
//   Seller? get seller => _seller;
//
//   bool? get isAccepted => _isAccepted;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_seller != null) {
//       map['seller'] = _seller?.toJson();
//     }
//     map['isAccepted'] = _isAccepted;
//     return map;
//   }
// }
//
// Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));
//
// String sellerToJson(Seller data) => json.encode(data.toJson());
//
// class Seller {
//   Seller({
//     Address? address,
//     BankDetails? bankDetails,
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? businessTag,
//     String? businessName,
//     String? email,
//     String? mobileNumber,
//     String? gender,
//     String? image,
//     int? followers,
//     int? following,
//     String? uniqueId,
//     String? fcmToken,
//     String? password,
//     dynamic channel,
//     bool? isLive,
//     dynamic liveSellingHistoryId,
//     bool? isBlock,
//     bool? isSeller,
//     bool? isAddByAdmin,
//     String? identity,
//     String? date,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _address = address;
//     _bankDetails = bankDetails;
//     _id = id;
//     _firstName = firstName;
//     _lastName = lastName;
//     _businessTag = businessTag;
//     _businessName = businessName;
//     _email = email;
//     _mobileNumber = mobileNumber;
//     _gender = gender;
//     _image = image;
//     _followers = followers;
//     _following = following;
//     _uniqueId = uniqueId;
//     _fcmToken = fcmToken;
//     _password = password;
//     _channel = channel;
//     _isLive = isLive;
//     _liveSellingHistoryId = liveSellingHistoryId;
//     _isBlock = isBlock;
//     _isSeller = isSeller;
//     _isAddByAdmin = isAddByAdmin;
//     _identity = identity;
//     _date = date;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }
//
//   Seller.fromJson(dynamic json) {
//     _address = json['address'] != null ? Address.fromJson(json['address']) : null;
//     _bankDetails = json['bankDetails'] != null ? BankDetails.fromJson(json['bankDetails']) : null;
//     _id = json['_id'];
//     _firstName = json['firstName'];
//     _lastName = json['lastName'];
//     _businessTag = json['businessTag'];
//     _businessName = json['businessName'];
//     _email = json['email'];
//     _mobileNumber = json['mobileNumber'];
//     _gender = json['gender'];
//     _image = json['image'];
//     _followers = json['followers'];
//     _following = json['following'];
//     _uniqueId = json['uniqueId'];
//     _fcmToken = json['fcmToken'];
//     _password = json['password'];
//     _channel = json['channel'];
//     _isLive = json['isLive'];
//     _liveSellingHistoryId = json['liveSellingHistoryId'];
//     _isBlock = json['isBlock'];
//     _isSeller = json['isSeller'];
//     _isAddByAdmin = json['isAddByAdmin'];
//     _identity = json['identity'];
//     _date = json['date'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }
//
//   Address? _address;
//   BankDetails? _bankDetails;
//   String? _id;
//   String? _firstName;
//   String? _lastName;
//   String? _businessTag;
//   String? _businessName;
//   String? _email;
//   String? _mobileNumber;
//   String? _gender;
//   String? _image;
//   int? _followers;
//   int? _following;
//   String? _uniqueId;
//   String? _fcmToken;
//   String? _password;
//   dynamic _channel;
//   bool? _isLive;
//   dynamic _liveSellingHistoryId;
//   bool? _isBlock;
//   bool? _isSeller;
//   bool? _isAddByAdmin;
//   String? _identity;
//   String? _date;
//   String? _createdAt;
//   String? _updatedAt;
//
//   Seller copyWith({
//     Address? address,
//     BankDetails? bankDetails,
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? businessTag,
//     String? businessName,
//     String? email,
//     String? mobileNumber,
//     String? gender,
//     String? image,
//     int? followers,
//     int? following,
//     String? uniqueId,
//     String? fcmToken,
//     String? password,
//     dynamic channel,
//     bool? isLive,
//     dynamic liveSellingHistoryId,
//     bool? isBlock,
//     bool? isSeller,
//     bool? isAddByAdmin,
//     String? identity,
//     String? date,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       Seller(
//         address: address ?? _address,
//         bankDetails: bankDetails ?? _bankDetails,
//         id: id ?? _id,
//         firstName: firstName ?? _firstName,
//         lastName: lastName ?? _lastName,
//         businessTag: businessTag ?? _businessTag,
//         businessName: businessName ?? _businessName,
//         email: email ?? _email,
//         mobileNumber: mobileNumber ?? _mobileNumber,
//         gender: gender ?? _gender,
//         image: image ?? _image,
//         followers: followers ?? _followers,
//         following: following ?? _following,
//         uniqueId: uniqueId ?? _uniqueId,
//         fcmToken: fcmToken ?? _fcmToken,
//         password: password ?? _password,
//         channel: channel ?? _channel,
//         isLive: isLive ?? _isLive,
//         liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
//         isBlock: isBlock ?? _isBlock,
//         isSeller: isSeller ?? _isSeller,
//         isAddByAdmin: isAddByAdmin ?? _isAddByAdmin,
//         identity: identity ?? _identity,
//         date: date ?? _date,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//
//   Address? get address => _address;
//
//   BankDetails? get bankDetails => _bankDetails;
//
//   String? get id => _id;
//
//   String? get firstName => _firstName;
//
//   String? get lastName => _lastName;
//
//   String? get businessTag => _businessTag;
//
//   String? get businessName => _businessName;
//
//   String? get email => _email;
//
//   String? get mobileNumber => _mobileNumber;
//
//   String? get gender => _gender;
//
//   String? get image => _image;
//
//   int? get followers => _followers;
//
//   int? get following => _following;
//
//   String? get uniqueId => _uniqueId;
//
//   String? get fcmToken => _fcmToken;
//
//   String? get password => _password;
//
//   dynamic get channel => _channel;
//
//   bool? get isLive => _isLive;
//
//   dynamic get liveSellingHistoryId => _liveSellingHistoryId;
//
//   bool? get isBlock => _isBlock;
//
//   bool? get isSeller => _isSeller;
//
//   bool? get isAddByAdmin => _isAddByAdmin;
//
//   String? get identity => _identity;
//
//   String? get date => _date;
//
//   String? get createdAt => _createdAt;
//
//   String? get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_address != null) {
//       map['address'] = _address?.toJson();
//     }
//     if (_bankDetails != null) {
//       map['bankDetails'] = _bankDetails?.toJson();
//     }
//     map['_id'] = _id;
//     map['firstName'] = _firstName;
//     map['lastName'] = _lastName;
//     map['businessTag'] = _businessTag;
//     map['businessName'] = _businessName;
//     map['email'] = _email;
//     map['mobileNumber'] = _mobileNumber;
//     map['gender'] = _gender;
//     map['image'] = _image;
//     map['followers'] = _followers;
//     map['following'] = _following;
//     map['uniqueId'] = _uniqueId;
//     map['fcmToken'] = _fcmToken;
//     map['password'] = _password;
//     map['channel'] = _channel;
//     map['isLive'] = _isLive;
//     map['liveSellingHistoryId'] = _liveSellingHistoryId;
//     map['isBlock'] = _isBlock;
//     map['isSeller'] = _isSeller;
//     map['isAddByAdmin'] = _isAddByAdmin;
//     map['identity'] = _identity;
//     map['date'] = _date;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }
// }
//
// BankDetails bankDetailsFromJson(String str) => BankDetails.fromJson(json.decode(str));
//
// String bankDetailsToJson(BankDetails data) => json.encode(data.toJson());
//
// class BankDetails {
//   BankDetails({
//     String? bankBusinessName,
//     String? bankName,
//     int? accountNumber,
//     String? iFSCCode,
//     String? branchName,
//   }) {
//     _bankBusinessName = bankBusinessName;
//     _bankName = bankName;
//     _accountNumber = accountNumber;
//     _iFSCCode = iFSCCode;
//     _branchName = branchName;
//   }
//
//   BankDetails.fromJson(dynamic json) {
//     _bankBusinessName = json['bankBusinessName'];
//     _bankName = json['bankName'];
//     _accountNumber = json['accountNumber'];
//     _iFSCCode = json['IFSCCode'];
//     _branchName = json['branchName'];
//   }
//
//   String? _bankBusinessName;
//   String? _bankName;
//   int? _accountNumber;
//   String? _iFSCCode;
//   String? _branchName;
//
//   BankDetails copyWith({
//     String? bankBusinessName,
//     String? bankName,
//     int? accountNumber,
//     String? iFSCCode,
//     String? branchName,
//   }) =>
//       BankDetails(
//         bankBusinessName: bankBusinessName ?? _bankBusinessName,
//         bankName: bankName ?? _bankName,
//         accountNumber: accountNumber ?? _accountNumber,
//         iFSCCode: iFSCCode ?? _iFSCCode,
//         branchName: branchName ?? _branchName,
//       );
//
//   String? get bankBusinessName => _bankBusinessName;
//
//   String? get bankName => _bankName;
//
//   int? get accountNumber => _accountNumber;
//
//   String? get iFSCCode => _iFSCCode;
//
//   String? get branchName => _branchName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['bankBusinessName'] = _bankBusinessName;
//     map['bankName'] = _bankName;
//     map['accountNumber'] = _accountNumber;
//     map['IFSCCode'] = _iFSCCode;
//     map['branchName'] = _branchName;
//     return map;
//   }
// }
//
// Address addressFromJson(String str) => Address.fromJson(json.decode(str));
//
// String addressToJson(Address data) => json.encode(data.toJson());
//
// class Address {
//   Address({
//     String? address,
//     String? landMark,
//     String? city,
//     int? pinCode,
//     String? state,
//     String? country,
//   }) {
//     _address = address;
//     _landMark = landMark;
//     _city = city;
//     _pinCode = pinCode;
//     _state = state;
//     _country = country;
//   }
//
//   Address.fromJson(dynamic json) {
//     _address = json['address'];
//     _landMark = json['landMark'];
//     _city = json['city'];
//     _pinCode = json['pinCode'];
//     _state = json['state'];
//     _country = json['country'];
//   }
//
//   String? _address;
//   String? _landMark;
//   String? _city;
//   int? _pinCode;
//   String? _state;
//   String? _country;
//
//   Address copyWith({
//     String? address,
//     String? landMark,
//     String? city,
//     int? pinCode,
//     String? state,
//     String? country,
//   }) =>
//       Address(
//         address: address ?? _address,
//         landMark: landMark ?? _landMark,
//         city: city ?? _city,
//         pinCode: pinCode ?? _pinCode,
//         state: state ?? _state,
//         country: country ?? _country,
//       );
//
//   String? get address => _address;
//
//   String? get landMark => _landMark;
//
//   String? get city => _city;
//
//   int? get pinCode => _pinCode;
//
//   String? get state => _state;
//
//   String? get country => _country;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['address'] = _address;
//     map['landMark'] = _landMark;
//     map['city'] = _city;
//     map['pinCode'] = _pinCode;
//     map['state'] = _state;
//     map['country'] = _country;
//     return map;
//   }
// }

// ===================

// import 'dart:convert';
//
// SellerDataModel sellerDataModelFromJson(String str) => SellerDataModel.fromJson(json.decode(str));
// String sellerDataModelToJson(SellerDataModel data) => json.encode(data.toJson());
//
// class SellerDataModel {
//   SellerDataModel({
//     bool? status,
//     String? message,
//     Seller? seller,
//     bool? isAccepted,
//   }) {
//     _status = status;
//     _message = message;
//     _seller = seller;
//     _isAccepted = isAccepted;
//   }
//
//   SellerDataModel.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
//     _isAccepted = json['isAccepted'];
//   }
//   bool? _status;
//   String? _message;
//   Seller? _seller;
//   bool? _isAccepted;
//   SellerDataModel copyWith({
//     bool? status,
//     String? message,
//     Seller? seller,
//     bool? isAccepted,
//   }) =>
//       SellerDataModel(
//         status: status ?? _status,
//         message: message ?? _message,
//         seller: seller ?? _seller,
//         isAccepted: isAccepted ?? _isAccepted,
//       );
//   bool? get status => _status;
//   String? get message => _message;
//   Seller? get seller => _seller;
//   bool? get isAccepted => _isAccepted;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_seller != null) {
//       map['seller'] = _seller?.toJson();
//     }
//     map['isAccepted'] = _isAccepted;
//     return map;
//   }
// }
//
// Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));
// String sellerToJson(Seller data) => json.encode(data.toJson());
//
// class Seller {
//   Seller({
//     Address? address,
//     BankDetails? bankDetails,
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? businessTag,
//     String? businessName,
//     String? email,
//     String? mobileNumber,
//     String? gender,
//     String? image,
//     int? followers,
//     int? following,
//     String? uniqueId,
//     String? fcmToken,
//     dynamic password,
//     String? userId,
//     dynamic channel,
//     bool? isLive,
//     dynamic liveSellingHistoryId,
//     bool? isBlock,
//     bool? isSeller,
//     bool? isFake,
//     dynamic video,
//     String? identity,
//     String? date,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _address = address;
//     _bankDetails = bankDetails;
//     _id = id;
//     _firstName = firstName;
//     _lastName = lastName;
//     _businessTag = businessTag;
//     _businessName = businessName;
//     _email = email;
//     _mobileNumber = mobileNumber;
//     _gender = gender;
//     _image = image;
//     _followers = followers;
//     _following = following;
//     _uniqueId = uniqueId;
//     _fcmToken = fcmToken;
//     _password = password;
//     _userId = userId;
//     _channel = channel;
//     _isLive = isLive;
//     _liveSellingHistoryId = liveSellingHistoryId;
//     _isBlock = isBlock;
//     _isSeller = isSeller;
//     _isFake = isFake;
//     _video = video;
//     _identity = identity;
//     _date = date;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }
//
//   Seller.fromJson(dynamic json) {
//     _address = json['address'] != null ? Address.fromJson(json['address']) : null;
//     _bankDetails = json['bankDetails'] != null ? BankDetails.fromJson(json['bankDetails']) : null;
//     _id = json['_id'];
//     _firstName = json['firstName'];
//     _lastName = json['lastName'];
//     _businessTag = json['businessTag'];
//     _businessName = json['businessName'];
//     _email = json['email'];
//     _mobileNumber = json['mobileNumber'];
//     _gender = json['gender'];
//     _image = json['image'];
//     _followers = json['followers'];
//     _following = json['following'];
//     _uniqueId = json['uniqueId'];
//     _fcmToken = json['fcmToken'];
//     _password = json['password'];
//     _userId = json['userId'];
//     _channel = json['channel'];
//     _isLive = json['isLive'];
//     _liveSellingHistoryId = json['liveSellingHistoryId'];
//     _isBlock = json['isBlock'];
//     _isSeller = json['isSeller'];
//     _isFake = json['isFake'];
//     _video = json['video'];
//     _identity = json['identity'];
//     _date = json['date'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }
//   Address? _address;
//   BankDetails? _bankDetails;
//   String? _id;
//   String? _firstName;
//   String? _lastName;
//   String? _businessTag;
//   String? _businessName;
//   String? _email;
//   String? _mobileNumber;
//   String? _gender;
//   String? _image;
//   int? _followers;
//   int? _following;
//   String? _uniqueId;
//   String? _fcmToken;
//   dynamic _password;
//   String? _userId;
//   dynamic _channel;
//   bool? _isLive;
//   dynamic _liveSellingHistoryId;
//   bool? _isBlock;
//   bool? _isSeller;
//   bool? _isFake;
//   dynamic _video;
//   String? _identity;
//   String? _date;
//   String? _createdAt;
//   String? _updatedAt;
//   Seller copyWith({
//     Address? address,
//     BankDetails? bankDetails,
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? businessTag,
//     String? businessName,
//     String? email,
//     String? mobileNumber,
//     String? gender,
//     String? image,
//     int? followers,
//     int? following,
//     String? uniqueId,
//     String? fcmToken,
//     dynamic password,
//     String? userId,
//     dynamic channel,
//     bool? isLive,
//     dynamic liveSellingHistoryId,
//     bool? isBlock,
//     bool? isSeller,
//     bool? isFake,
//     dynamic video,
//     String? identity,
//     String? date,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       Seller(
//         address: address ?? _address,
//         bankDetails: bankDetails ?? _bankDetails,
//         id: id ?? _id,
//         firstName: firstName ?? _firstName,
//         lastName: lastName ?? _lastName,
//         businessTag: businessTag ?? _businessTag,
//         businessName: businessName ?? _businessName,
//         email: email ?? _email,
//         mobileNumber: mobileNumber ?? _mobileNumber,
//         gender: gender ?? _gender,
//         image: image ?? _image,
//         followers: followers ?? _followers,
//         following: following ?? _following,
//         uniqueId: uniqueId ?? _uniqueId,
//         fcmToken: fcmToken ?? _fcmToken,
//         password: password ?? _password,
//         userId: userId ?? _userId,
//         channel: channel ?? _channel,
//         isLive: isLive ?? _isLive,
//         liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
//         isBlock: isBlock ?? _isBlock,
//         isSeller: isSeller ?? _isSeller,
//         isFake: isFake ?? _isFake,
//         video: video ?? _video,
//         identity: identity ?? _identity,
//         date: date ?? _date,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   Address? get address => _address;
//   BankDetails? get bankDetails => _bankDetails;
//   String? get id => _id;
//   String? get firstName => _firstName;
//   String? get lastName => _lastName;
//   String? get businessTag => _businessTag;
//   String? get businessName => _businessName;
//   String? get email => _email;
//   String? get mobileNumber => _mobileNumber;
//   String? get gender => _gender;
//   String? get image => _image;
//   int? get followers => _followers;
//   int? get following => _following;
//   String? get uniqueId => _uniqueId;
//   String? get fcmToken => _fcmToken;
//   dynamic get password => _password;
//   String? get userId => _userId;
//   dynamic get channel => _channel;
//   bool? get isLive => _isLive;
//   dynamic get liveSellingHistoryId => _liveSellingHistoryId;
//   bool? get isBlock => _isBlock;
//   bool? get isSeller => _isSeller;
//   bool? get isFake => _isFake;
//   dynamic get video => _video;
//   String? get identity => _identity;
//   String? get date => _date;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_address != null) {
//       map['address'] = _address?.toJson();
//     }
//     if (_bankDetails != null) {
//       map['bankDetails'] = _bankDetails?.toJson();
//     }
//     map['_id'] = _id;
//     map['firstName'] = _firstName;
//     map['lastName'] = _lastName;
//     map['businessTag'] = _businessTag;
//     map['businessName'] = _businessName;
//     map['email'] = _email;
//     map['mobileNumber'] = _mobileNumber;
//     map['gender'] = _gender;
//     map['image'] = _image;
//     map['followers'] = _followers;
//     map['following'] = _following;
//     map['uniqueId'] = _uniqueId;
//     map['fcmToken'] = _fcmToken;
//     map['password'] = _password;
//     map['userId'] = _userId;
//     map['channel'] = _channel;
//     map['isLive'] = _isLive;
//     map['liveSellingHistoryId'] = _liveSellingHistoryId;
//     map['isBlock'] = _isBlock;
//     map['isSeller'] = _isSeller;
//     map['isFake'] = _isFake;
//     map['video'] = _video;
//     map['identity'] = _identity;
//     map['date'] = _date;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }
// }
//
// BankDetails bankDetailsFromJson(String str) => BankDetails.fromJson(json.decode(str));
// String bankDetailsToJson(BankDetails data) => json.encode(data.toJson());
//
// class BankDetails {
//   BankDetails({
//     String? bankBusinessName,
//     String? bankName,
//     double? accountNumber,
//     String? iFSCCode,
//     String? branchName,
//   }) {
//     _bankBusinessName = bankBusinessName;
//     _bankName = bankName;
//     _accountNumber = accountNumber;
//     _iFSCCode = iFSCCode;
//     _branchName = branchName;
//   }
//
//   BankDetails.fromJson(dynamic json) {
//     _bankBusinessName = json['bankBusinessName'];
//     _bankName = json['bankName'];
//     _accountNumber = json['accountNumber'];
//     _iFSCCode = json['IFSCCode'];
//     _branchName = json['branchName'];
//   }
//   String? _bankBusinessName;
//   String? _bankName;
//   double? _accountNumber;
//   String? _iFSCCode;
//   String? _branchName;
//   BankDetails copyWith({
//     String? bankBusinessName,
//     String? bankName,
//     double? accountNumber,
//     String? iFSCCode,
//     String? branchName,
//   }) =>
//       BankDetails(
//         bankBusinessName: bankBusinessName ?? _bankBusinessName,
//         bankName: bankName ?? _bankName,
//         accountNumber: accountNumber ?? _accountNumber,
//         iFSCCode: iFSCCode ?? _iFSCCode,
//         branchName: branchName ?? _branchName,
//       );
//   String? get bankBusinessName => _bankBusinessName;
//   String? get bankName => _bankName;
//   double? get accountNumber => _accountNumber;
//   String? get iFSCCode => _iFSCCode;
//   String? get branchName => _branchName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['bankBusinessName'] = _bankBusinessName;
//     map['bankName'] = _bankName;
//     map['accountNumber'] = _accountNumber;
//     map['IFSCCode'] = _iFSCCode;
//     map['branchName'] = _branchName;
//     return map;
//   }
// }
//
// Address addressFromJson(String str) => Address.fromJson(json.decode(str));
// String addressToJson(Address data) => json.encode(data.toJson());
//
// class Address {
//   Address({
//     String? address,
//     String? landMark,
//     String? city,
//     int? pinCode,
//     String? state,
//     String? country,
//   }) {
//     _address = address;
//     _landMark = landMark;
//     _city = city;
//     _pinCode = pinCode;
//     _state = state;
//     _country = country;
//   }
//
//   Address.fromJson(dynamic json) {
//     _address = json['address'];
//     _landMark = json['landMark'];
//     _city = json['city'];
//     _pinCode = json['pinCode'];
//     _state = json['state'];
//     _country = json['country'];
//   }
//   String? _address;
//   String? _landMark;
//   String? _city;
//   int? _pinCode;
//   String? _state;
//   String? _country;
//   Address copyWith({
//     String? address,
//     String? landMark,
//     String? city,
//     int? pinCode,
//     String? state,
//     String? country,
//   }) =>
//       Address(
//         address: address ?? _address,
//         landMark: landMark ?? _landMark,
//         city: city ?? _city,
//         pinCode: pinCode ?? _pinCode,
//         state: state ?? _state,
//         country: country ?? _country,
//       );
//   String? get address => _address;
//   String? get landMark => _landMark;
//   String? get city => _city;
//   int? get pinCode => _pinCode;
//   String? get state => _state;
//   String? get country => _country;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['address'] = _address;
//     map['landMark'] = _landMark;
//     map['city'] = _city;
//     map['pinCode'] = _pinCode;
//     map['state'] = _state;
//     map['country'] = _country;
//     return map;
//   }
// }

import 'dart:convert';

SellerDataModel sellerDataModelFromJson(String str) => SellerDataModel.fromJson(json.decode(str));
String sellerDataModelToJson(SellerDataModel data) => json.encode(data.toJson());

class SellerDataModel {
  SellerDataModel({
    bool? status,
    String? message,
    Seller? seller,
    bool? isAccepted,
  }) {
    _status = status;
    _message = message;
    _seller = seller;
    _isAccepted = isAccepted;
  }

  SellerDataModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _isAccepted = json['isAccepted'];
  }
  bool? _status;
  String? _message;
  Seller? _seller;
  bool? _isAccepted;
  SellerDataModel copyWith({
    bool? status,
    String? message,
    Seller? seller,
    bool? isAccepted,
  }) =>
      SellerDataModel(
        status: status ?? _status,
        message: message ?? _message,
        seller: seller ?? _seller,
        isAccepted: isAccepted ?? _isAccepted,
      );
  bool? get status => _status;
  String? get message => _message;
  Seller? get seller => _seller;
  bool? get isAccepted => _isAccepted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    map['isAccepted'] = _isAccepted;
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
    int? followers,
    int? following,
    String? uniqueId,
    String? fcmToken,
    dynamic password,
    String? userId,
    dynamic channel,
    bool? isLive,
    dynamic liveSellingHistoryId,
    bool? isBlock,
    bool? isSeller,
    bool? isFake,
    dynamic video,
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
    _fcmToken = fcmToken;
    _password = password;
    _userId = userId;
    _channel = channel;
    _isLive = isLive;
    _liveSellingHistoryId = liveSellingHistoryId;
    _isBlock = isBlock;
    _isSeller = isSeller;
    _isFake = isFake;
    _video = video;
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
    _fcmToken = json['fcmToken'];
    _password = json['password'];
    _userId = json['userId'];
    _channel = json['channel'];
    _isLive = json['isLive'];
    _liveSellingHistoryId = json['liveSellingHistoryId'];
    _isBlock = json['isBlock'];
    _isSeller = json['isSeller'];
    _isFake = json['isFake'];
    _video = json['video'];
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
  int? _followers;
  int? _following;
  String? _uniqueId;
  String? _fcmToken;
  dynamic _password;
  String? _userId;
  dynamic _channel;
  bool? _isLive;
  dynamic _liveSellingHistoryId;
  bool? _isBlock;
  bool? _isSeller;
  bool? _isFake;
  dynamic _video;
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
    int? followers,
    int? following,
    String? uniqueId,
    String? fcmToken,
    dynamic password,
    String? userId,
    dynamic channel,
    bool? isLive,
    dynamic liveSellingHistoryId,
    bool? isBlock,
    bool? isSeller,
    bool? isFake,
    dynamic video,
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
        fcmToken: fcmToken ?? _fcmToken,
        password: password ?? _password,
        userId: userId ?? _userId,
        channel: channel ?? _channel,
        isLive: isLive ?? _isLive,
        liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
        isBlock: isBlock ?? _isBlock,
        isSeller: isSeller ?? _isSeller,
        isFake: isFake ?? _isFake,
        video: video ?? _video,
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
  int? get followers => _followers;
  int? get following => _following;
  String? get uniqueId => _uniqueId;
  String? get fcmToken => _fcmToken;
  dynamic get password => _password;
  String? get userId => _userId;
  dynamic get channel => _channel;
  bool? get isLive => _isLive;
  dynamic get liveSellingHistoryId => _liveSellingHistoryId;
  bool? get isBlock => _isBlock;
  bool? get isSeller => _isSeller;
  bool? get isFake => _isFake;
  dynamic get video => _video;
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
    map['fcmToken'] = _fcmToken;
    map['password'] = _password;
    map['userId'] = _userId;
    map['channel'] = _channel;
    map['isLive'] = _isLive;
    map['liveSellingHistoryId'] = _liveSellingHistoryId;
    map['isBlock'] = _isBlock;
    map['isSeller'] = _isSeller;
    map['isFake'] = _isFake;
    map['video'] = _video;
    map['identity'] = _identity;
    map['date'] = _date;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

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

Address addressFromJson(String str) => Address.fromJson(json.decode(str));
String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    String? address,
    String? landMark,
    String? city,
    int? pinCode,
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
  int? _pinCode;
  String? _state;
  String? _country;
  Address copyWith({
    String? address,
    String? landMark,
    String? city,
    int? pinCode,
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
  int? get pinCode => _pinCode;
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
