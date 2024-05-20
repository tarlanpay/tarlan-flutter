import 'dart:convert';

ReceiptResponse receiptResponseFromJson(String str) => ReceiptResponse.fromJson(json.decode(str));

String receiptResponseToJson(ReceiptResponse data) => json.encode(data.toJson());

class ReceiptResponse {
  bool status;
  String message;
  ReceiptInfo result;

  ReceiptResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory ReceiptResponse.fromJson(Map<String, dynamic> json) => ReceiptResponse(
        status: json["status"],
        message: json["message"],
        result: ReceiptInfo.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
      };
}

class ReceiptInfo {
  int transactionId;
  num orderAmount;
  num upperCommissionAmount;
  num totalAmount;
  String currency;
  String projectName;
  String logo;
  String acquirerName;
  String paymentOrganization;
  DateTime dateTime;
  String maskedPan;
  String transactionStatusName;
  String transactionType;
  String email;
  String phone;

  ReceiptInfo({
    required this.transactionId,
    required this.orderAmount,
    required this.upperCommissionAmount,
    required this.totalAmount,
    required this.currency,
    required this.projectName,
    required this.logo,
    required this.acquirerName,
    required this.paymentOrganization,
    required this.dateTime,
    required this.maskedPan,
    required this.transactionStatusName,
    required this.transactionType,
    required this.email,
    required this.phone,
  });

  factory ReceiptInfo.fromJson(Map<String, dynamic> json) => ReceiptInfo(
        transactionId: json["transaction_id"],
        orderAmount: json["order_amount"],
        upperCommissionAmount: json["upper_commission_amount"],
        totalAmount: json["total_amount"],
        currency: json["currency"],
        projectName: json["project_name"],
        logo: json["logo"],
        acquirerName: json["acquirer_name"],
        paymentOrganization: json["payment_organization"],
        dateTime: DateTime.parse(json["date_time"]),
        maskedPan: json["masked_pan"],
        transactionStatusName: json["transaction_status_name"],
        transactionType: json["transaction_type"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "order_amount": orderAmount,
        "upper_commission_amount": upperCommissionAmount,
        "total_amount": totalAmount,
        "currency": currency,
        "project_name": projectName,
        "logo": logo,
        "acquirer_name": acquirerName,
        "payment_organization": paymentOrganization,
        "date_time": dateTime.toIso8601String(),
        "masked_pan": maskedPan,
        "transaction_status_name": transactionStatusName,
        "transaction_type": transactionType,
        "email": email,
        "phone": phone,
      };
}
