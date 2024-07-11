import 'dart:convert';

PayInPostData payInPostDataFromJson(String str) => PayInPostData.fromJson(json.decode(str));

String payInPostDataToJson(PayInPostData data) => json.encode(data.toJson());

class PayInPostData {
  int? _transactionId;
  String? _encryptedCard;
  String? _userPhone;
  String? _userEmail;

  String? _transactionHash;
  bool? _save;

  PayInPostData({
    int? transactionId,
    String? encryptedCard,
    String? userPhone,
    String? userEmail,
    String? transactionHash,
    bool? save,
  })  : _transactionId = transactionId,
        _encryptedCard = encryptedCard,
        _userPhone = userPhone,
        _userEmail = userEmail,
        _transactionHash = transactionHash,
        _save = save;

  int? get transactionId => _transactionId;

  set transactionId(int? value) {
    _transactionId = value;
  }

  String? get encryptedCard => _encryptedCard;

  set encryptedCard(String? value) {
    _encryptedCard = value;
  }

  String? get userPhone => _userPhone;
  set userPhone(String? value) {
    _userPhone = value;
  }

  String? get userEmail => _userEmail;

  set userEmail(String? value) {
    _userEmail = value;
  }

  String? get transactionHash => _transactionHash;

  set transactionHash(String? value) {
    _transactionHash = value;
  }

  bool? get save => _save;

  set save(bool? value) {
    _save = value;
  }

  factory PayInPostData.fromJson(Map<String, dynamic> json) => PayInPostData(
        transactionId: json["transaction_id"],
        encryptedCard: json["encrypted_card"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        transactionHash: json["transaction_hash"],
        save: json["save"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "encrypted_card": encryptedCard,
        "user_phone": userPhone,
        "user_email": userEmail,
        "transaction_hash": transactionHash,
        "save": save,
      };
}
