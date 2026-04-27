class UpcomingLivesModel {
  bool? status;
  String? message;
  List<UpcomingLive>? data;

  UpcomingLivesModel({this.status, this.message, this.data});

  factory UpcomingLivesModel.fromJson(Map<String, dynamic> json) => UpcomingLivesModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? List<UpcomingLive>.from((json['data'] as List).map((e) => UpcomingLive.fromJson(e))) : [],
      );
}

class UpcomingLive {
  String? id;
  String? sellerId;
  String? sellerName;
  String? sellerImage;
  /// Cover image the seller uploaded when scheduling this specific show.
  /// Distinct from [sellerImage], which is the seller's avatar.
  String? image;
  String? title;
  String? description;
  DateTime? scheduledAt;
  bool? hasReminder;

  UpcomingLive({
    this.id,
    this.sellerId,
    this.sellerName,
    this.sellerImage,
    this.image,
    this.title,
    this.description,
    this.scheduledAt,
    this.hasReminder,
  });

  factory UpcomingLive.fromJson(Map<String, dynamic> json) => UpcomingLive(
        id: json['_id']?.toString(),
        sellerId: json['sellerId']?.toString(),
        sellerName: json['sellerName'],
        sellerImage: json['sellerImage'],
        image: json['image']?.toString(),
        title: json['title'],
        description: json['description'],
        scheduledAt: json['scheduledAt'] != null ? DateTime.tryParse(json['scheduledAt'].toString()) : null,
        hasReminder: json['hasReminder'] ?? false,
      );
}
