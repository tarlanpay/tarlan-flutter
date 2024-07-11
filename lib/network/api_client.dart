import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '/network/environment.dart';
import '/network/http_method.dart';
import '/network/request.dart';
import '../data/api_constants.dart';
import '../data/model/common/session_data.dart';
import 'api_type.dart';

class ApiClient {
  bool _isProd() => SessionData().getEnvironment() == Environment.prod;

  String baseUrl(ApiType apiType) {
    switch (apiType) {
      case ApiType.merchant:
        return _isProd() ? ApiConstants.merchantProdBaseUrl : ApiConstants.merchantSandboxBaseUrl;
      case ApiType.main:
        return _isProd() ? ApiConstants.prodBaseUrl : ApiConstants.sandBoxBaseUrl;
      case ApiType.cdn:
        return _isProd() ? ApiConstants.cdnProdBaseUrl : ApiConstants.cdnSandboxBaseUrl;
    }
  }

  Future<http.Response> send(Request request) async {
    final uri = Uri.https(baseUrl(request.apiType ?? ApiType.main), request.path, request.queryParams);
    return _doNetworkCall(uri, request);
  }

  Future<http.Response> _doNetworkCall(Uri uri, Request request) async {
    HttpWithMiddleware httpWithMiddleware = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    return request.method == HttpMethod.post
        ? httpWithMiddleware.post(uri, headers: _getHeaders(), body: request.body)
        : httpWithMiddleware.get(uri, headers: _getHeaders());
  }

  Map<String, String>? _getHeaders() => {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-csrf': SessionData().getCsrf() ?? "",
        'Cookie': "session=${SessionData().getSession()}",
      };
}
