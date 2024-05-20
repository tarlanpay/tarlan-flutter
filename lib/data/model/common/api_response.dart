class ApiResponse<T> {
  final bool status;
  final String message;
  final T? result;
  final int? statusCode;

  ApiResponse({
    required this.status,
    required this.message,
    this.result,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) create) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      result: json['result'] != null ? create(json['result']) : null,
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'result': result,
        'status_code': statusCode,
      };
}
