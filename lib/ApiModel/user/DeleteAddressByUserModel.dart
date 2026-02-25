// ignore_for_file: file_names
import 'dart:convert';

DeleteAddressByUserModel deleteAddressByUserModelFromJson(String str) =>
    DeleteAddressByUserModel.fromJson(json.decode(str));

String deleteAddressByUserModelToJson(DeleteAddressByUserModel data) => json.encode(data.toJson());

class DeleteAddressByUserModel {
  DeleteAddressByUserModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  DeleteAddressByUserModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  bool? _status;
  String? _message;

  DeleteAddressByUserModel copyWith({
    bool? status,
    String? message,
  }) =>
      DeleteAddressByUserModel(
        status: status ?? _status,
        message: message ?? _message,
      );

  bool? get status => _status;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
