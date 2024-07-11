import 'package:flutter/widgets.dart';
import 'package:tarlan_payments/data/model/public_key/public_key_response.dart';

import '../../../network/api_client.dart';
import '../../../network/request.dart';
import '../../api_constants.dart';
import '../../model/common/session_data.dart';
import '../../model/common/url_data.dart';
import '../../model/receipt/receipt_info.dart';
import '../../model/transaction/transaction_info.dart';
import '../errors.dart';

class TransactionWebService {
  final api = ApiClient();

  String removeNewLinesAndTrim(String input) {
    String noNewLines = input.replaceAll(RegExp(r'[\n\r]+'), '');
    String trimmed = noNewLines.trim();
    return trimmed;
  }

  Future<TransactionInfo> getTransactionInfo() async {
    UrlData? urlData = SessionData().getUrlData();
    final queryParameters = {
      'transaction_id': urlData?.transactionId,
      'hash': urlData?.hash,
    };
    final request = Request(path: ApiConstants.pathTransactionInfo, queryParams: queryParameters);
    try {
      final response = await api.send(request);
      final csrfHeader = response.headers['x-csrf'];
      SessionData().setCsrf(csrfHeader);
      final sessionHeader = response.headers['set-cookie'];
      if (sessionHeader != null) {
        final cookies = _parseCookies(sessionHeader)['session'];
        if (cookies != null) {
          SessionData().setSession(removeNewLinesAndTrim(cookies));
        }
      }
      if (response.statusCode == 200) {
        return transactionInfoResponseFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }

  Map<String, String> _parseCookies(String rawCookies) {
    final cookies = <String, String>{};
    final cookiePairs = rawCookies.split(';');
    for (var pair in cookiePairs) {
      final keyValue = pair.split('=');
      if (keyValue.length == 2) {
        cookies[keyValue[0].trim()] = keyValue[1];
      }
    }
    return cookies;
  }

  Future<ReceiptInfo> getReceipt() async {
    UrlData? urlData = SessionData().getUrlData();
    final queryParameters = {
      'id': urlData?.transactionId,
      'hash': urlData?.hash,
    };
    final request = Request(path: ApiConstants.pathReceipt, queryParams: queryParameters);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return receiptResponseFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }

  Future<ReceiptInfo> downloadPdf() async {
    UrlData? urlData = SessionData().getUrlData();
    final queryParameters = {
      'hash': urlData?.hash,
    };
    final request = Request(path: ApiConstants.pathReceipt, queryParams: queryParameters);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return receiptResponseFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }

  Future<String> retrievePublicKey() async {
    final request = Request(path: ApiConstants.pathPublicKey);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return publicKeyResponseFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
  }
}
