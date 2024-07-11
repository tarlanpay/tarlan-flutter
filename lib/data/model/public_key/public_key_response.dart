import 'dart:convert';

PublicKeyResponse publicKeyResponseFromJson(String str) => PublicKeyResponse.fromJson(json.decode(str));

String publicKeyResponseToJson(PublicKeyResponse data) => json.encode(data.toJson());

class PublicKeyResponse {
  bool status;
  String message;
  String result;

  PublicKeyResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory PublicKeyResponse.fromJson(Map<String, dynamic> json) => PublicKeyResponse(
        status: json["status"],
        message: json["message"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result,
      };
}
