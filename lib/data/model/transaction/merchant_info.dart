import 'dart:convert';

MerchantInfoResponse merchantInfoFromJson(String str) => MerchantInfoResponse.fromJson(json.decode(str));

String merchantInfoToJson(MerchantInfoResponse data) => json.encode(data.toJson());

class MerchantInfoResponse {
  bool status;
  String message;
  MerchantInfo result;

  MerchantInfoResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory MerchantInfoResponse.fromJson(Map<String, dynamic> json) => MerchantInfoResponse(
        status: json["status"],
        message: json["message"],
        result: MerchantInfo.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
      };
}

class MerchantInfo {
  int projectId;
  int merchantId;
  String storeName;
  String logoFilePath;
  bool hasEmail;
  bool requiredEmail;
  bool hasPhone;
  bool requiredPhone;
  String defaultLanguage;
  int timeout;
  bool hasRedirect;
  bool hasDefaultCard;
  bool showDescription;
  dynamic descriptionLanguage;

  MerchantInfo({
    required this.projectId,
    required this.merchantId,
    required this.storeName,
    required this.logoFilePath,
    required this.hasEmail,
    required this.requiredEmail,
    required this.hasPhone,
    required this.requiredPhone,
    required this.defaultLanguage,
    required this.timeout,
    required this.hasRedirect,
    required this.hasDefaultCard,
    required this.showDescription,
    required this.descriptionLanguage,
  });

  factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
        projectId: json["project_id"],
        merchantId: json["merchant_id"],
        storeName: json["store_name"],
        logoFilePath: json["logo_file_path"],
        hasEmail: json["has_email"],
        requiredEmail: json["required_email"],
        hasPhone: json["has_phone"],
        requiredPhone: json["required_phone"],
        defaultLanguage: json["default_language"],
        timeout: json["timeout"],
        hasRedirect: json["has_redirect"],
        hasDefaultCard: json["has_default_card"],
        showDescription: json["show_description"],
        descriptionLanguage: json["description_language"],
      );

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "merchant_id": merchantId,
        "store_name": storeName,
        "logo_file_path": logoFilePath,
        "has_email": hasEmail,
        "required_email": requiredEmail,
        "has_phone": hasPhone,
        "required_phone": requiredPhone,
        "default_language": defaultLanguage,
        "timeout": timeout,
        "has_redirect": hasRedirect,
        "has_default_card": hasDefaultCard,
        "show_description": showDescription,
        "description_language": descriptionLanguage,
      };
}
