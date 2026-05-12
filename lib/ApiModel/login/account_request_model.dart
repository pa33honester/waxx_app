// Response DTO for POST accountRequest/create — the in-app sign-up
// assistant chatbot's submission endpoint. The backend returns the
// usual { status, message } envelope; there's no useful data payload
// for the client beyond that.
class AccountRequestModel {
  final bool status;
  final String message;

  AccountRequestModel({required this.status, required this.message});

  factory AccountRequestModel.fromJson(Map<String, dynamic> json) {
    return AccountRequestModel(
      status: json["status"] == true,
      message: (json["message"] ?? json["error"] ?? "").toString(),
    );
  }
}
