import 'dart:convert';

PayOutPostData payOutPostDataFromJson(String str) => PayOutPostData.fromJson(json.decode(str));

String payOutPostDataToJson(PayOutPostData data) => json.encode(data.toJson());

class PayOutPostData {
  String? userEmail;
  String? userPhone;
  int? transactionId;
  String? pan;
  String? transactionHash;

  PayOutPostData({
    this.userEmail,
    this.userPhone,
    this.transactionId,
    this.pan,
    this.transactionHash,
  });

  factory PayOutPostData.fromJson(Map<String, dynamic> json) => PayOutPostData(
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        transactionId: json["transaction_id"],
        pan: json["pan"],
        transactionHash: json["transaction_hash"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_phone": userPhone,
        "transaction_id": transactionId,
        "pan": pan,
        "transaction_hash": transactionHash,
      };
}
