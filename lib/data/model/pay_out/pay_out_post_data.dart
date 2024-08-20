import 'dart:convert';

PayOutPostData payOutPostDataFromJson(String str) => PayOutPostData.fromJson(json.decode(str));

String payOutPostDataToJson(PayOutPostData data) => json.encode(data.toJson());

class PayOutPostData {
  String? userEmail;
  String? userPhone;
  int? transactionId;
  String? encryptedPan;
  String? transactionHash;

  PayOutPostData({
    this.userEmail,
    this.userPhone,
    this.transactionId,
    this.encryptedPan,
    this.transactionHash,
  });

  factory PayOutPostData.fromJson(Map<String, dynamic> json) => PayOutPostData(
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        transactionId: json["transaction_id"],
        encryptedPan: json["encrypted_pan"],
        transactionHash: json["transaction_hash"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_phone": userPhone,
        "transaction_id": transactionId,
        "encrypted_pan": encryptedPan,
        "transaction_hash": transactionHash,
      };
}
