// ignore_for_file: file_names
import 'dart:convert';

AddToFavoriteModel addToFavoriteFromJson(String str) => AddToFavoriteModel.fromJson(json.decode(str));

String addToFavoriteToJson(AddToFavoriteModel data) => json.encode(data.toJson());

class AddToFavoriteModel {
  AddToFavoriteModel({
    bool? status,
    String? message,
    bool? isFavorite,
  }) {
    _status = status;
    _message = message;
    _isFavorite = isFavorite;
  }

  AddToFavoriteModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _isFavorite = json['isFavorite'];
  }

  bool? _status;
  String? _message;
  bool? _isFavorite;

  AddToFavoriteModel copyWith({
    bool? status,
    String? message,
    bool? isFavorite,
  }) =>
      AddToFavoriteModel(
        status: status ?? _status,
        message: message ?? _message,
        isFavorite: isFavorite ?? _isFavorite,
      );

  bool? get status => _status;

  String? get message => _message;

  bool? get isFavorite => _isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['isFavorite'] = _isFavorite;
    return map;
  }
}
