// ignore_for_file: file_names
import 'dart:convert';

UpdatePasswordModel updatePasswordModelFromJson(String str) => UpdatePasswordModel.fromJson(json.decode(str));

String updatePasswordModelToJson(UpdatePasswordModel data) => json.encode(data.toJson());

class UpdatePasswordModel {
  UpdatePasswordModel({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  UpdatePasswordModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  bool? _status;
  String? _message;
  User? _user;

  UpdatePasswordModel copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      UpdatePasswordModel(
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
    String? id,
    String? firstName,
    String? lastName,
    String? password,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _password = password;
  }

  User.fromJson(dynamic json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _password = json['password'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;
  String? _password;

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? password,
  }) =>
      User(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        password: password ?? _password,
      );

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['password'] = _password;
    return map;
  }
}
