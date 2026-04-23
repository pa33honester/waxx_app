class ScheduledLiveModel {
  bool? status;
  String? message;
  ScheduledLive? data;

  ScheduledLiveModel({this.status, this.message, this.data});

  factory ScheduledLiveModel.fromJson(Map<String, dynamic> json) => ScheduledLiveModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? ScheduledLive.fromJson(json['data']) : null,
      );
}

class ScheduledLiveListModel {
  bool? status;
  String? message;
  List<ScheduledLive>? data;

  ScheduledLiveListModel({this.status, this.message, this.data});

  factory ScheduledLiveListModel.fromJson(Map<String, dynamic> json) => ScheduledLiveListModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? List<ScheduledLive>.from((json['data'] as List).map((e) => ScheduledLive.fromJson(e))) : [],
      );
}

class ScheduledLive {
  String? id;
  String? sellerId;
  String? title;
  String? description;
  DateTime? scheduledAt;
  String? status;

  ScheduledLive({this.id, this.sellerId, this.title, this.description, this.scheduledAt, this.status});

  factory ScheduledLive.fromJson(Map<String, dynamic> json) => ScheduledLive(
        id: json['_id']?.toString(),
        sellerId: json['sellerId']?.toString(),
        title: json['title'],
        description: json['description'],
        scheduledAt: json['scheduledAt'] != null ? DateTime.tryParse(json['scheduledAt'].toString()) : null,
        status: json['status'],
      );
}
