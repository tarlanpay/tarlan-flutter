import 'dart:convert';

ResumePostData resumePostDataFromJson(String str) => ResumePostData.fromJson(json.decode(str));

String resumePostDataToJson(ResumePostData data) => json.encode(data.toJson());

class ResumePostData {
  int? transactionId;
  String? transactionHash;

  ResumePostData({
    this.transactionId,
    this.transactionHash,
  });

  factory ResumePostData.fromJson(Map<String, dynamic> json) => ResumePostData(
        transactionId: json["transaction_id"],
        transactionHash: json["transaction_hash"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "transaction_hash": transactionHash,
      };
}
