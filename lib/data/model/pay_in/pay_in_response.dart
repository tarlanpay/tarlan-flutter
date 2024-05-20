class PayInResult {
  int? transactionId;
  String? transactionStatusCode;
  ThreeDs? threeDs;
  Fingerprint? fingerprint;
  String? acquirerCode;

  PayInResult({
    this.transactionId,
    this.transactionStatusCode,
    this.threeDs,
    this.fingerprint,
    this.acquirerCode,
  });

  factory PayInResult.fromJson(Map<String, dynamic> json) => PayInResult(
        transactionId: json["transaction_id"],
        transactionStatusCode: json["transaction_status_code"],
        threeDs: json["three_ds"] == null ? null : ThreeDs.fromJson(json["three_ds"]),
        fingerprint: json["fingerprint"] == null ? null : Fingerprint.fromJson(json["fingerprint"]),
        acquirerCode: json["acquirer_code"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "transaction_status_code": transactionStatusCode,
        "three_ds": threeDs?.toJson(),
        "fingerprint": fingerprint?.toJson(),
        "acquirer_code": acquirerCode,
      };
}

class Fingerprint {
  String? methodUrl;
  String? methodData;

  Fingerprint({
    this.methodUrl,
    this.methodData,
  });

  factory Fingerprint.fromJson(Map<String, dynamic> json) => Fingerprint(
        methodUrl: json["method_url"],
        methodData: json["method_data"],
      );

  Map<String, dynamic> toJson() => {
        "method_url": methodUrl,
        "method_data": methodData,
      };
}

class ThreeDs {
  bool? is3Ds;
  Map<String, String>? params;
  String? action;
  String? termUrl;

  ThreeDs({
    this.is3Ds,
    this.params,
    this.action,
    this.termUrl,
  });

  factory ThreeDs.fromJson(Map<String, dynamic> json) {
    Map<String, String> params = {};
    json['params'].forEach((key, value) {
      params[key] = value.toString();
    });
    return ThreeDs(
      is3Ds: json["is_3ds"],
      params: params,
      action: json["action"],
      termUrl: json["termUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_3ds": is3Ds,
      "params": params,
      "action": action,
      "termUrl": termUrl,
    };
  }
}
