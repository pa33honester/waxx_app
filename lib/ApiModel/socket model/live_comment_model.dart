import 'dart:convert';

LiveCommentModel liveCommentModelFromJson(String str) => LiveCommentModel.fromJson(json.decode(str));

String liveCommentModelToJson(LiveCommentModel data) => json.encode(data.toJson());

class LiveCommentModel {
  LiveCommentModel({
    String? image,
    String? name,
    String? comment,
    String? liveSellingHistoryId,
  }) {
    _image = image;
    _name = name;
    _comment = comment;
    _liveSellingHistoryId = liveSellingHistoryId;
  }

  LiveCommentModel.fromJson(dynamic json) {
    _image = json['image'];
    _name = json['name'];
    _comment = json['comment'];
    _liveSellingHistoryId = json['liveSellingHistoryId'];
  }

  String? _image;
  String? _name;
  String? _comment;
  String? _liveSellingHistoryId;

  LiveCommentModel copyWith({
    String? image,
    String? name,
    String? comment,
    String? liveSellingHistoryId,
  }) =>
      LiveCommentModel(
        image: image ?? _image,
        name: name ?? _name,
        comment: comment ?? _comment,
        liveSellingHistoryId: liveSellingHistoryId ?? _liveSellingHistoryId,
      );

  String? get image => _image;

  String? get name => _name;

  String? get comment => _comment;

  String? get liveSellingHistoryId => _liveSellingHistoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['name'] = _name;
    map['comment'] = _comment;
    map['liveSellingHistoryId'] = _liveSellingHistoryId;
    return map;
  }
}
