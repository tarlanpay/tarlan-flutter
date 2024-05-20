import 'dart:convert';

PayInPostData payInPostDataFromJson(String str) => PayInPostData.fromJson(json.decode(str));

String payInPostDataToJson(PayInPostData data) => json.encode(data.toJson());

class PayInPostData {
  int? _transactionId;
  String? _fullName;
  String? _userPhone;
  String? _userEmail;
  String? _cvc;
  String? _month;
  String? _pan;
  String? _year;
  String? _transactionHash;
  bool? _save;

  PayInPostData({
    int? transactionId,
    String? fullName,
    String? userPhone,
    String? userEmail,
    String? cvc,
    String? month,
    String? pan,
    String? year,
    String? transactionHash,
    bool? save,
  })  : _transactionId = transactionId,
        _fullName = fullName,
        _userPhone = userPhone,
        _userEmail = userEmail,
        _cvc = cvc,
        _month = month,
        _pan = pan,
        _year = year,
        _transactionHash = transactionHash,
        _save = save;

  int? get transactionId => _transactionId;

  set transactionId(int? value) {
    _transactionId = value;
  }

  String? get fullName => _fullName;

  set fullName(String? value) {
    _fullName = value;
  }

  String? get userPhone => _userPhone;

  set userPhone(String? value) {
    _userPhone = value;
  }

  String? get userEmail => _userEmail;

  set userEmail(String? value) {
    _userEmail = value;
  }

  String? get cvc => _cvc;

  set cvc(String? value) {
    _cvc = value;
  }

  String? get month => _month;

  set month(String? value) {
    _month = value;
  }

  String? get pan => _pan;

  set pan(String? value) {
    _pan = value;
  }

  String? get year => _year;

  set year(String? value) {
    _year = value;
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
        fullName: json["full_name"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        cvc: json["cvc"],
        month: json["month"],
        pan: json["pan"],
        year: json["year"],
        transactionHash: json["transaction_hash"],
        save: json["save"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "full_name": fullName,
        "user_phone": userPhone,
        "user_email": userEmail,
        "cvc": cvc,
        "month": month,
        "pan": pan,
        "year": year,
        "transaction_hash": transactionHash,
        "save": save,
      };
}
