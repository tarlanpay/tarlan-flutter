// To parse this JSON data, do
//
//     final transactionInfoResponse = transactionInfoResponseFromJson(jsonString);

import 'dart:convert';

TransactionInfoResponse transactionInfoResponseFromJson(String str) =>
    TransactionInfoResponse.fromJson(json.decode(str));

String transactionInfoResponseToJson(TransactionInfoResponse data) => json.encode(data.toJson());

class TransactionInfoResponse {
  bool status;
  String message;
  TransactionInfo result;

  TransactionInfoResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory TransactionInfoResponse.fromJson(Map<String, dynamic> json) => TransactionInfoResponse(
        status: json["status"],
        message: json["message"],
        result: TransactionInfo.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
      };
}

class TransactionInfo {
  int transactionId;
  String projectReferenceId;
  String projectClientId;
  int projectId;
  int merchantId;
  num orderAmount;
  num upperCommissionAmount;
  num totalAmount;
  String logo;
  TransactionInfoUrls transactionInfo;
  TransactionStatus transactionStatus;
  TransactionStatus transactionType;
  List<TransactionStatus> availableTypes;
  List<TransactionCard> cards;
  String description;

  TransactionInfo({
    required this.transactionId,
    required this.projectReferenceId,
    required this.projectClientId,
    required this.projectId,
    required this.merchantId,
    required this.orderAmount,
    required this.upperCommissionAmount,
    required this.totalAmount,
    required this.logo,
    required this.transactionInfo,
    required this.transactionStatus,
    required this.transactionType,
    required this.availableTypes,
    required this.cards,
    required this.description,
  });

  factory TransactionInfo.fromJson(Map<String, dynamic> json) => TransactionInfo(
        transactionId: json["transaction_id"],
        projectReferenceId: json["project_reference_id"],
        projectClientId: json["project_client_id"],
        projectId: json["project_id"],
        merchantId: json["merchant_id"],
        orderAmount: json["order_amount"],
        upperCommissionAmount: json["upper_commission_amount"],
        totalAmount: json["total_amount"],
        logo: json["logo"],
        transactionInfo: TransactionInfoUrls.fromJson(json["transaction_info"]),
        transactionStatus: TransactionStatus.fromJson(json["transaction_status"]),
        transactionType: TransactionStatus.fromJson(json["transaction_type"]),
        availableTypes: List<TransactionStatus>.from(json["available_types"].map((x) => TransactionStatus.fromJson(x))),
        cards: List<TransactionCard>.from(json["cards"].map((x) => TransactionCard.fromJson(x))),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "project_reference_id": projectReferenceId,
        "project_client_id": projectClientId,
        "project_id": projectId,
        "merchant_id": merchantId,
        "order_amount": orderAmount,
        "upper_commission_amount": upperCommissionAmount,
        "total_amount": totalAmount,
        "logo": logo,
        "transaction_info": transactionInfo.toJson(),
        "transaction_status": transactionStatus.toJson(),
        "transaction_type": transactionType.toJson(),
        "available_types": List<dynamic>.from(availableTypes.map((x) => x.toJson())),
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
        "description": description,
      };
}

class TransactionStatus {
  String code;
  String name;

  TransactionStatus({
    required this.code,
    required this.name,
  });

  factory TransactionStatus.fromJson(Map<String, dynamic> json) => TransactionStatus(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}

class TransactionInfoUrls {
  String callbackUrl;
  String successRedirectUrl;
  String failureRedirectUrl;

  TransactionInfoUrls({
    required this.callbackUrl,
    required this.successRedirectUrl,
    required this.failureRedirectUrl,
  });

  factory TransactionInfoUrls.fromJson(Map<String, dynamic> json) => TransactionInfoUrls(
        callbackUrl: json["callback_url"],
        successRedirectUrl: json["success_redirect_url"],
        failureRedirectUrl: json["failure_redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "callback_url": callbackUrl,
        "success_redirect_url": successRedirectUrl,
        "failure_redirect_url": failureRedirectUrl,
      };
}

class TransactionCard {
  String cardToken;
  String maskedPan;

  TransactionCard({
    required this.cardToken,
    required this.maskedPan,
  });

  factory TransactionCard.fromJson(Map<String, dynamic> json) =>
      TransactionCard(cardToken: json["card_token"], maskedPan: json["masked_pan"]);

  Map<String, dynamic> toJson() => {
        "card_token": cardToken,
        "masked_pan": maskedPan,
      };
}
