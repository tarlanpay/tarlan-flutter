import 'dart:convert';

OneClickPostData oneClickPostDataFromJson(String str) => OneClickPostData.fromJson(json.decode(str));

String oneClickPostDataToJson(OneClickPostData data) => json.encode(data.toJson());

class OneClickPostData {
  String? userEmail;
  String? userPhone;
  int? transactionId;
  String? transactionHash;
  String? encryptedId;

  OneClickPostData({
    this.userEmail,
    this.userPhone,
    this.transactionId,
    this.transactionHash,
    this.encryptedId,
  });

  factory OneClickPostData.fromJson(Map<String, dynamic> json) => OneClickPostData(
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
        transactionId: json["transaction_id"],
        transactionHash: json["transaction_hash"],
        encryptedId: json["encrypted_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_phone": userPhone,
        "transaction_id": transactionId,
        "transaction_hash": transactionHash,
        "encrypted_id": encryptedId,
      };
}
