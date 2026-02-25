import 'dart:convert';

ReelDeleteModel reelDeleteModelFromJson(String str) => ReelDeleteModel.fromJson(json.decode(str));
String reelDeleteModelToJson(ReelDeleteModel data) => json.encode(data.toJson());

class ReelDeleteModel {
  ReelDeleteModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  ReelDeleteModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  bool? _status;
  String? _message;
  ReelDeleteModel copyWith({
    bool? status,
    String? message,
  }) =>
      ReelDeleteModel(
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
