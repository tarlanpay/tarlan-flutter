import 'api_type.dart';
import 'http_method.dart';

class Request {
  final HttpMethod method;
  final String path;
  final String? body;
  final ApiType? apiType;
  final Map<String, dynamic>? queryParams;

  Request({this.method = HttpMethod.get, required this.path, this.body, this.apiType = ApiType.main, this.queryParams});
}
