import 'dart:convert';

ColorsInfoResponse colorsInfoFromJson(String str) => ColorsInfoResponse.fromJson(json.decode(str));

String colorsInfoToJson(ColorsInfoResponse data) => json.encode(data.toJson());

class ColorsInfoResponse {
  bool status;
  String message;
  ColorsInfo result;

  ColorsInfoResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory ColorsInfoResponse.fromJson(Map<String, dynamic> json) => ColorsInfoResponse(
        status: json["status"],
        message: json["message"],
        result: ColorsInfo.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
      };
}

class ColorsInfo {
  int projectId;
  int merchantId;
  String viewType;
  String mainFormColor;
  String secondaryFormColor;
  String mainTextColor;
  String secondaryTextColor;
  String mainInputColor;
  String secondaryInputColor;
  String mainTextInputColor;
  String inputLabelColor;

  ColorsInfo({
    required this.projectId,
    required this.merchantId,
    required this.viewType,
    required this.mainFormColor,
    required this.secondaryFormColor,
    required this.mainTextColor,
    required this.secondaryTextColor,
    required this.mainInputColor,
    required this.secondaryInputColor,
    required this.mainTextInputColor,
    required this.inputLabelColor,
  });

  factory ColorsInfo.fromJson(Map<String, dynamic> json) => ColorsInfo(
        projectId: json["project_id"],
        merchantId: json["merchant_id"],
        viewType: json["view_type"],
        mainFormColor: json["main_form_color"],
        secondaryFormColor: json["secondary_form_color"],
        mainTextColor: json["main_text_color"],
        secondaryTextColor: json["secondary_text_color"],
        mainInputColor: json["main_input_color"],
        secondaryInputColor: json["secondary_input_color"],
        mainTextInputColor: json["main_text_input_color"],
        inputLabelColor: json["input_label_color"],
      );

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "merchant_id": merchantId,
        "view_type": viewType,
        "main_form_color": mainFormColor,
        "secondary_form_color": secondaryFormColor,
        "main_text_color": mainTextColor,
        "secondary_text_color": secondaryTextColor,
        "main_input_color": mainInputColor,
        "secondary_input_color": secondaryInputColor,
        "main_text_input_color": mainTextInputColor,
        "input_label_color": inputLabelColor,
      };
}
