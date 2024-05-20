import 'dart:convert';

import 'package:flutter/widgets.dart';
import '/network/api_client.dart';
import '/network/http_method.dart';

import '../../../network/request.dart';
import '../../api_constants.dart';
import '../../model/common/api_response.dart';
import '../../model/common/post_data/one_click_post_data.dart';
import '../../model/common/session_data.dart';
import '../../model/common/url_data.dart';
import '../../model/pay_in/pay_in_post_data.dart';
import '../../model/pay_in/pay_in_response.dart';
import '../../model/pay_out/pay_out_post_data.dart';
import '../errors.dart';

class PaymentWebService {
  final api = ApiClient();

  Future<ApiResponse<PayInResult>> cardLink(PayInPostData postData) async {
    UrlData urlData = SessionData().getUrlData()!;
    postData.transactionId = int.parse(urlData.transactionId);
    postData.transactionHash = urlData.hash;
    postData.pan = postData.pan?.replaceAll(' ', '');
    postData.save = true;
    final request = Request(path: ApiConstants.pathCardLink, body: jsonEncode(postData.toJson()));
    try {
      final response = await api.send(request);
      return ApiResponse<PayInResult>.fromJson(
        jsonDecode(response.body),
        (json) => PayInResult.fromJson(json),
      );
    } catch (e) {
      throw ErrorsResponse(response: e.toString());
    }
  }

  Future<ApiResponse<PayInResult>> payIn(PayInPostData postData) async {
    UrlData urlData = SessionData().getUrlData()!;
    postData.transactionId = int.parse(urlData.transactionId);
    postData.transactionHash = urlData.hash;
    postData.pan = postData.pan?.replaceAll(' ', '');
    final request = Request(path: ApiConstants.pathPayIn, body: jsonEncode(postData.toJson()));
    try {
      final response = await api.send(request);
      return ApiResponse<PayInResult>.fromJson(
        jsonDecode(response.body),
        (json) => PayInResult.fromJson(json),
      );
    } catch (e) {
      throw ErrorsResponse(response: e.toString());
    }
  }

  Future<String?> payOut(PayOutPostData postData) async {
    UrlData urlData = SessionData().getUrlData()!;
    postData.transactionId = int.parse(urlData.transactionId);
    postData.transactionHash = urlData.hash;
    postData.pan = postData.pan?.replaceAll(' ', '');
    final request = Request(path: ApiConstants.pathPayOut, body: jsonEncode(postData.toJson()));
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }

  Future<ApiResponse<PayInResult>> oneClickPayIn(OneClickPostData postData) async {
    UrlData urlData = SessionData().getUrlData()!;
    postData.transactionId = int.parse(urlData.transactionId);
    postData.transactionHash = urlData.hash;
    final request =
        Request(method: HttpMethod.post, path: ApiConstants.pathOneClickPayIn, body: jsonEncode(postData.toJson()));
    try {
      final response = await api.send(request);
      return ApiResponse<PayInResult>.fromJson(
        jsonDecode(response.body),
        (json) => PayInResult.fromJson(json),
      );
    } catch (e) {
      throw ErrorsResponse(response: e.toString());
    }
  }

  Future<String?> oneClickPayOut(OneClickPostData postData) async {
    UrlData urlData = SessionData().getUrlData()!;
    postData.transactionId = int.parse(urlData.transactionId);
    postData.transactionHash = urlData.hash;
    final request = Request(path: ApiConstants.pathOneClickPayOut, body: jsonEncode(postData.toJson()));
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }
}
