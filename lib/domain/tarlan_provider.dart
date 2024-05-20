import 'package:flutter/widgets.dart';
import '/data/model/common/status.dart';
import '/data/model/common/type.dart';
import '/data/model/transaction/colors_info.dart';
import '/data/model/transaction/merchant_info.dart';
import '/data/model/transaction/transaction_info.dart';
import '/data/webservices/merchant/merchant_webservice.dart';
import '/data/webservices/payment/payment_webservice.dart';
import '/data/webservices/transaction/transaction_webservice.dart';
import '/domain/flow.dart';
import '/domain/payment_helper.dart';
import '/domain/payment_result_route.dart';

import '../../data/model/pay_in/pay_in_response.dart';
import '../data/model/receipt/receipt_info.dart';

final class TarlanProvider with ChangeNotifier {
  late ColorsInfo colorsInfo;
  late MerchantInfo merchantInfo;
  late TransactionInfo transactionInfo;
  late ReceiptInfo receiptInfo;
  late TarlanType type;
  late TarlanStatus status;
  late ThreeDs threeDs;

  MerchantWebService merchantWebService = MerchantWebService();
  TransactionWebService transactionWebService = TransactionWebService();
  PaymentWebService paymentWebService = PaymentWebService();

  late PaymentHelper paymentHelper;

  var isLoading = true;
  var currentFlow = TarlanFlow.form;
  ErrorResultRoute? error;

  var disposed = false;
  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void setFlow(TarlanFlow flow) {
    currentFlow = flow;
    notifyListeners();
  }

  Future<void> load() async {
    try {
      paymentHelper = PaymentHelper();
      colorsInfo = await merchantWebService.getColorsInfo();
      merchantInfo = await merchantWebService.getMerchantInfo();
      transactionInfo = await transactionWebService.getTransactionInfo();
      type = TarlanType.fromTransactionInfo(transactionInfo);
      status = TarlanStatus.fromTransactionInfo(transactionInfo);

      checkForOneClick();

      if (disposed) {
        return;
      }
      isLoading = false;
      notifyListeners();
    } catch (_) {
      if (disposed) {
        return;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void checkForOneClick() {
    if (transactionInfo.cards.isNotEmpty) {
      switchToOneClick();
      paymentHelper.oneClickPostData.encryptedId = transactionInfo.cards.first.cardToken;
    } else {
      switchToRegularPay();
    }
  }

  void setNewType(TarlanType newType) {
    type = newType;
  }

  bool enableDropdown() {
    return type != TarlanType.cardLink;
  }

  bool goToReceipt() {
    return type != TarlanType.cardLink && !_isNewTransaction();
  }

  bool goToCardLinkResult() {
    return type == TarlanType.cardLink && !_isNewTransaction();
  }

  bool _isNewTransaction() => status == TarlanStatus.newTransaction;

  void switchToOneClick() {
    if (type == TarlanType.payIn) {
      setNewType(TarlanType.oneClickPayIn);
    } else if (type == TarlanType.payOut) {
      setNewType(TarlanType.oneClickPayOut);
    }
  }

  void switchToRegularPay() {
    if (type == TarlanType.oneClickPayIn) {
      setNewType(TarlanType.payIn);
    } else if (type == TarlanType.oneClickPayOut) {
      setNewType(TarlanType.payOut);
    }
  }

  bool isOneClick() => type == TarlanType.oneClickPayIn || type == TarlanType.oneClickPayOut;

  Future makePayment() async {
    isLoading = true;
    notifyListeners();
    final paymentResultRoute = await paymentHelper.pay(type, paymentWebService);
    checkPaymentResultRoute(paymentResultRoute);
  }

  void checkPaymentResultRoute(PaymentResultRoute route) {
    if (route is ErrorResultRoute) {
      _launchErrorFlow(route);
    } else if (route is ReceiptResultRoute) {
      _launchReceipt();
    } else if (route is ThreeDsResultRoute) {
      _launch3DS(route.threeDs);
    } else if (route is FingerprintResultRoute) {
      _launchFingerprint(route.fingerprint);
    }
  }

  void _launch3DS(ThreeDs data) {
    print("Launching 3DS: ${data.toJson()}");
    threeDs = data;
    currentFlow = TarlanFlow.threeDs;
    notifyListeners();
  }

  void _launchFingerprint(Fingerprint fingerprint) {
    isLoading = false;
  }

  Future<void> _launchReceipt() async {
    try {
      receiptInfo = await transactionWebService.getReceipt();
      if (disposed) {
        return;
      }
      isLoading = false;
      notifyListeners();
    } catch (_) {
      if (disposed) {
        return;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void _launchErrorFlow(ErrorResultRoute route) {
    isLoading = false;
    error = route;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  bool isClassicTheme() => colorsInfo.viewType == 'classic' || colorsInfo.viewType.isEmpty == true;

  bool showDetails() {
    final isTypeApplicable = type == TarlanType.payIn || type == TarlanType.cardLink;
    return isTypeApplicable && _isNewTransaction();
  }

  void setCardNumber(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.payInPostData.pan = value;
    } else if (type == TarlanType.payOut) {
      paymentHelper.payOutPostData.pan = value;
    }
  }

  void notify() {
    notifyListeners();
  }

  void setOneClickCardToken(String value) {
    paymentHelper.oneClickPostData.encryptedId = value;
    switchToOneClick();
    notifyListeners();
  }

  void setExpiryMonth(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.payInPostData.month = value;
    }
  }

  void setExpiryYear(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.payInPostData.year = value;
    }
  }

  void setCVV(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.payInPostData.cvc = value;
    }
  }

  void setCardHolderName(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.payInPostData.fullName = value;
    }
  }

  void setSaveCard(bool? saveCard) {
    if (type == TarlanType.payIn) {
      paymentHelper.payInPostData.save = saveCard ?? true;
    }
  }
}
