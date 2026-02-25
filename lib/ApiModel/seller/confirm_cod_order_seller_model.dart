class ConfirmCodOrderSellerModel {
  final bool status;
  final String message;

  ConfirmCodOrderSellerModel({required this.status, required this.message});

  factory ConfirmCodOrderSellerModel.fromJson(Map<String, dynamic> json) {
    return ConfirmCodOrderSellerModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
