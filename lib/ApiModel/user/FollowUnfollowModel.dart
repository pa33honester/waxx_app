// ignore_for_file: file_names
import 'dart:convert';

FollowUnfollowModel followUnfollowModelFromJson(String str) => FollowUnfollowModel.fromJson(json.decode(str));

String followUnfollowModelToJson(FollowUnfollowModel data) => json.encode(data.toJson());

class FollowUnfollowModel {
  FollowUnfollowModel({
    bool? status,
    String? message,
    bool? isFollow,
  }) {
    _status = status;
    _message = message;
    _isFollow = isFollow;
  }

  FollowUnfollowModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _isFollow = json['isFollow'];
  }

  bool? _status;
  String? _message;
  bool? _isFollow;

  FollowUnfollowModel copyWith({
    bool? status,
    String? message,
    bool? isFollow,
  }) =>
      FollowUnfollowModel(
        status: status ?? _status,
        message: message ?? _message,
        isFollow: isFollow ?? _isFollow,
      );

  bool? get status => _status;

  String? get message => _message;

  bool? get isFollow => _isFollow;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['isFollow'] = _isFollow;
    return map;
  }
}
