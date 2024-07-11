import 'package:flutter/widgets.dart';
import 'package:tarlan_payments/data/card_deactivate/card_deactivate_post_data.dart';
import 'package:tarlan_payments/data/model/common/post_data/card_encrypt_data.dart';

import '/data/model/common/type.dart';
import '/data/webservices/payment/payment_webservice.dart';
import '/domain/error_dialog_type.dart';
import '/domain/payment_result_route.dart';
import '../data/model/common/post_data/one_click_post_data.dart';
import '../data/model/pay_in/pay_in_post_data.dart';
import '../data/model/pay_in/pay_in_response.dart';
import '../data/model/pay_out/pay_out_post_data.dart';

class PaymentHelper {
  late PayInPostData _payInPostData;

  PayInPostData get payInPostData => _payInPostData;

  late PayOutPostData _payOutPostData;

  PayOutPostData get payOutPostData => _payOutPostData;

  late OneClickPostData _oneClickPostData;

  OneClickPostData get oneClickPostData => _oneClickPostData;

  late CardDeactivatePostData _cardDeactivatePostData;

  CardDeactivatePostData get cardDeactivatePostData => _cardDeactivatePostData;

  late CardEncryptData _cardEncryptData;

  CardEncryptData get cardEncryptData => _cardEncryptData;

  TarlanType? type;

  PaymentHelper() {
    _payInPostData = PayInPostData();
    _payOutPostData = PayOutPostData();
    _oneClickPostData = OneClickPostData();
    _cardDeactivatePostData = CardDeactivatePostData();
    _cardEncryptData = CardEncryptData();
  }

  Future<PaymentResultRoute> doTransaction(TarlanType type, PaymentWebService paymentWebService) async {
    this.type = type;
    try {
      switch (type) {
        case TarlanType.payIn:
          final response = await paymentWebService.payIn(payInPostData);
          if (response.status) {
            return checkResult(response.result);
          } else {
            return ErrorResultRoute(type: ErrorDialogType.transaction, message: response.message);
          }
        case TarlanType.payOut:
          await paymentWebService.payOut(payOutPostData);
          return ReceiptResultRoute();
        case TarlanType.cardLink:
          final response = await paymentWebService.cardLink(payInPostData);
          if (response.status) {
            return checkResult(response.result);
          } else {
            return ErrorResultRoute(type: ErrorDialogType.transaction, message: response.message);
          }
        case TarlanType.oneClickPayIn:
          final response = await paymentWebService.oneClickPayIn(oneClickPostData);
          if (response.status) {
            return checkResult(response.result);
          } else {
            return ErrorResultRoute(type: ErrorDialogType.transaction, message: response.message);
          }
        case TarlanType.oneClickPayOut:
          await paymentWebService.oneClickPayOut(oneClickPostData);
          return ReceiptResultRoute();
        case TarlanType.unsupported:
          debugPrint("THIS TarlanType IS NOT SUPPORTED");
          return ErrorResultRoute(type: ErrorDialogType.unsupported);
      }
    } catch (e) {
      debugPrint("Payment Error: $e");
      return ErrorResultRoute(type: ErrorDialogType.transaction, message: e.toString());
    }
  }

  Future<PaymentResultRoute> checkResult(PayInResult? result) async {
    var status = result?.transactionStatusCode;
    if (status == 'threeds_waiting' && result?.threeDs != null) {
      var threeDs = result!.threeDs!;
      if (threeDs.params != null && threeDs.action != null) {
        return ThreeDsResultRoute(threeDs: threeDs);
      } else {
        if (type == TarlanType.cardLink) {
          return SuccessDialogResultRoute();
        } else {
          return ReceiptResultRoute();
        }
      }
    } else if (status == 'fingerprint' && result?.fingerprint != null) {
      final fingerprint = result!.fingerprint!;
      if (fingerprint.methodData != null && fingerprint.methodUrl != null) {
        return FingerprintResultRoute(fingerprint: fingerprint);
      } else {
        if (type == TarlanType.cardLink) {
          return SuccessDialogResultRoute();
        } else {
          return ReceiptResultRoute();
        }
      }
    } else {
      if (type == TarlanType.cardLink) {
        return SuccessDialogResultRoute();
      } else {
        return ReceiptResultRoute();
      }
    }
  }
}
