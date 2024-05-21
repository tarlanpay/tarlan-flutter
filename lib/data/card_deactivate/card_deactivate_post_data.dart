import 'dart:convert';

CardDeactivatePostData cardDeactivatePostDataFromJson(String str) => CardDeactivatePostData.fromJson(json.decode(str));

String cardDeactivatePostDataToJson(CardDeactivatePostData data) => json.encode(data.toJson());

class CardDeactivatePostData {
  String? encryptedCardId;
  int? projectId;
  int? transactionId;
  String? transactionHash;

  CardDeactivatePostData({
    this.encryptedCardId,
    this.projectId,
    this.transactionId,
    this.transactionHash,
  });

  factory CardDeactivatePostData.fromJson(Map<String, dynamic> json) => CardDeactivatePostData(
        encryptedCardId: json["encrypted_card_id"],
        projectId: json["project_id"],
        transactionId: json["transaction_id"],
        transactionHash: json["transaction_hash"],
      );

  Map<String, dynamic> toJson() => {
        "encrypted_card_id": encryptedCardId,
        "project_id": projectId,
        "transaction_id": transactionId,
        "transaction_hash": transactionHash,
      };
}
