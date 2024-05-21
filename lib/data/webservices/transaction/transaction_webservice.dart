import 'package:flutter/widgets.dart';

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

  Future<TransactionInfo> getTransactionInfo() async {
    UrlData? urlData = SessionData().getUrlData();
    final queryParameters = {
      'transaction_id': urlData?.transactionId,
      'hash': urlData?.hash,
    };
    final request = Request(path: ApiConstants.pathTransactionInfo, queryParams: queryParameters);
    try {
      final response = await api.send(request);
      if (response.statusCode == 200) {
        return transactionInfoResponseFromJson(response.body).result;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorsResponse(response: e.toString());
    }
    throw ErrorsResponse(response: 'Unknown');
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
}
