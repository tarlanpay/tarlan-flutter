import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/widgets.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tarlan_payments/data/api_constants.dart';
import 'package:tarlan_payments/data/model/common/session_data.dart';
import 'package:tarlan_payments/domain/error_dialog_type.dart';
import 'package:tarlan_payments/domain/validators/regex.dart';
import 'package:tarlan_payments/network/api_client.dart';

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
import '../network/api_type.dart';

final class TarlanProvider with ChangeNotifier {
  late ColorsInfo colorsInfo;
  late MerchantInfo merchantInfo;
  late TransactionInfo transactionInfo;
  late ReceiptInfo receiptInfo;
  late TarlanType type;
  late TarlanStatus status;
  late ThreeDs threeDs;
  late Fingerprint fingerprint;

  MerchantWebService merchantWebService = MerchantWebService();
  TransactionWebService transactionWebService = TransactionWebService();
  PaymentWebService paymentWebService = PaymentWebService();

  late PaymentHelper paymentHelper;

  var isLoading = true;
  var currentFlow = TarlanFlow.form;
  ErrorResultRoute? error;

  String? emailError;
  String? cardError;
  String? expiryError;
  String? cvvError;
  String? cardHolderError;
  String? phoneError;

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
    isLoading = true;
    try {
      paymentHelper = PaymentHelper();
      colorsInfo = await merchantWebService.getColorsInfo();
      merchantInfo = await merchantWebService.getMerchantInfo();
      transactionInfo = await transactionWebService.getTransactionInfo();
      type = TarlanType.fromTransactionInfo(transactionInfo);
      status = TarlanStatus.fromTransactionInfo(transactionInfo);

      if (goToReceipt()) {
        _launchReceipt();
      } else if (goToCardLinkResult()) {
        _launchSuccessFlow(SuccessDialogResultRoute());
      } else {
        checkForOneClick();

        if (disposed) {
          return;
        }
        isLoading = false;
        notifyListeners();
      }
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

  String encryptCardData(String publicKey) {
    final parser = RSAKeyParser();
    final publicKey = parser.parse(SessionData().getPublicKey()!) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1));

    String cardData;

    if (type == TarlanType.payOut) {
      cardData = jsonEncode({
        'pan': paymentHelper.cardEncryptData.pan,
      });
    } else {
      cardData = jsonEncode({
        'pan': paymentHelper.cardEncryptData.pan,
        'exp_month': paymentHelper.cardEncryptData.month,
        'exp_year': paymentHelper.cardEncryptData.year,
        'cvc': paymentHelper.cardEncryptData.cvc,
        'full_name': paymentHelper.cardEncryptData.fullName,
      });
    }

    final encryptedData = encrypter.encrypt(cardData);
    return encryptedData.base64;
  }

  Future createTransaction() async {
    isLoading = true;
    notifyListeners();

    if (SessionData().getPublicKey() == null) {
      final publicKeyResult = await transactionWebService.retrievePublicKey();
      SessionData().setPublicKey(publicKeyResult);
    }
    final publicKey = SessionData().getPublicKey()!;
    if (type == TarlanType.payOut) {
      paymentHelper.payOutPostData.encryptedPan = encryptCardData(publicKey);
    } else {
      paymentHelper.payInPostData.encryptedCard = encryptCardData(publicKey);
    }
    final paymentResultRoute = await paymentHelper.doTransaction(type, paymentWebService);
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
    } else if (route is SuccessDialogResultRoute) {
      _launchSuccessFlow(route);
    }
  }

  void _launch3DS(ThreeDs data) {
    debugPrint("Launching 3DS: ${data.toJson()}");
    threeDs = data;
    currentFlow = TarlanFlow.threeDs;
    notifyListeners();
  }

  void threeDsFinished() {
    isLoading = true;
    if (type == TarlanType.cardLink) {
      _verifyCardLink();
    } else {
      notifyListeners();
      _launchReceipt();
    }
  }

  void _launchFingerprint(Fingerprint data) {
    fingerprint = data;
    resumeFingerprint();
  }

  Future<void> resumeFingerprint() async {
    try {
      var resumeResult = await paymentWebService.resume();
      var resultRoute = await paymentHelper.checkResult(resumeResult.result);
      checkPaymentResultRoute(resultRoute);
      if (disposed) {
        return;
      }
      isLoading = false;
    } catch (_) {
      if (disposed) {
        return;
      }
      error = ErrorResultRoute(type: ErrorDialogType.unsupported, message: 'Unknown');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _verifyCardLink() async {
    try {
      transactionInfo = await transactionWebService.getTransactionInfo();

      if (transactionInfo.transactionStatus.code != "success") {
        if (disposed) {
          return;
        }
        error = ErrorResultRoute(type: ErrorDialogType.unsupported, message: transactionInfo.transactionStatus.name);
        currentFlow = TarlanFlow.error;
        isLoading = false;
        notifyListeners();
        return;
      }
      _launchSuccessFlow(SuccessDialogResultRoute());
    } catch (_) {
      if (disposed) {
        return;
      }
      error = ErrorResultRoute(type: ErrorDialogType.unsupported, message: 'Unknown');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _launchReceipt() async {
    try {
      transactionInfo = await transactionWebService.getTransactionInfo();

      if (transactionInfo.transactionStatus.code != "success") {
        if (disposed) {
          return;
        }
        error = ErrorResultRoute(type: ErrorDialogType.unsupported, message: transactionInfo.transactionStatus.name);
        isLoading = false;
        notifyListeners();
        return;
      }

      currentFlow = TarlanFlow.receipt;
      receiptInfo = await transactionWebService.getReceipt();
      if (disposed) {
        return;
      }
      currentFlow = TarlanFlow.receipt;
      isLoading = false;
      notifyListeners();
    } catch (_) {
      if (disposed) {
        return;
      }
      error = ErrorResultRoute(type: ErrorDialogType.unsupported, message: 'Unknown');
      isLoading = false;
      notifyListeners();
    }
  }

  void _launchErrorFlow(ErrorResultRoute route) {
    isLoading = false;
    currentFlow = TarlanFlow.error;
    error = route;
    notifyListeners();
  }

  void _launchSuccessFlow(SuccessDialogResultRoute route) {
    isLoading = false;
    currentFlow = TarlanFlow.success;
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

  bool showRememberCardOption() {
    return type == TarlanType.payIn;
  }

  bool isCardLink() {
    return type == TarlanType.cardLink;
  }

  void setCardNumber(String value) {
    final pan = value.replaceAll(' ', '');
    paymentHelper.cardEncryptData.pan = pan;
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
      paymentHelper.cardEncryptData.month = value;
    }
  }

  void setExpiryYear(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.cardEncryptData.year = value;
    }
  }

  void setCVV(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.cardEncryptData.cvc = value;
    }
  }

  void setCardHolderName(String value) {
    if (type == TarlanType.payIn || type == TarlanType.cardLink) {
      paymentHelper.cardEncryptData.fullName = value;
    }
  }

  void setSaveCard(bool? saveCard) {
    if (type == TarlanType.payIn) {
      paymentHelper.payInPostData.save = saveCard ?? true;
    }
  }

  void setUserPhone(String? phone) {
    switch (type) {
      case TarlanType.cardLink:
        paymentHelper.payInPostData.userPhone = phone;
      case TarlanType.payIn:
        paymentHelper.payInPostData.userPhone = phone;
      case TarlanType.payOut:
        paymentHelper.payOutPostData.userPhone = phone;
      case TarlanType.oneClickPayIn:
        paymentHelper.oneClickPostData.userPhone = phone;
      case TarlanType.oneClickPayOut:
        paymentHelper.oneClickPostData.userPhone = phone;
      case TarlanType.unsupported:
        paymentHelper.payInPostData.userPhone = phone;
    }
  }

  void setUserEmail(String? email) {
    switch (type) {
      case TarlanType.cardLink:
        paymentHelper.payInPostData.userEmail = email;
      case TarlanType.payIn:
        paymentHelper.payInPostData.userEmail = email;
      case TarlanType.payOut:
        paymentHelper.payOutPostData.userEmail = email;
      case TarlanType.oneClickPayIn:
        paymentHelper.oneClickPostData.userEmail = email;
      case TarlanType.oneClickPayOut:
        paymentHelper.oneClickPostData.userEmail = email;
      case TarlanType.unsupported:
        paymentHelper.payInPostData.userEmail = email;
    }
  }

  void validateForm() {
    if (validateCard() &&
        validateExpiry() &&
        validateCvv() &&
        validateCardholder() &&
        validatePhone() &&
        validateEmail()) {
      createTransaction();
    }
  }

  bool validateCard() {
    if (type == TarlanType.oneClickPayIn || type == TarlanType.oneClickPayOut) {
      return true;
    }
    String card = paymentHelper.cardEncryptData.pan ?? '';
    if (card.isEmpty) {
      cardError = "Необходимо указать номер карты";
      notifyListeners();
      return false;
    }

    if (card.length != 16) {
      cardError = "Номер карты указан неверно";
      notifyListeners();
      return false;
    }

    cardError = null;
    notifyListeners();
    return true;
  }

  bool validateExpiry() {
    if (type != TarlanType.payIn && type != TarlanType.cardLink) {
      return true;
    }
    String month = paymentHelper.cardEncryptData.month ?? '';
    String year = paymentHelper.cardEncryptData.year ?? '';
    if (month.isEmpty || year.isEmpty) {
      expiryError = "Укажите срок действия карты";
      notifyListeners();
      return false;
    }

    expiryError = null;
    notifyListeners();
    return true;
  }

  bool validateCvv() {
    if (type != TarlanType.payIn && type != TarlanType.cardLink) {
      return true;
    }
    String cvv = paymentHelper.cardEncryptData.cvc ?? '';
    if (cvv.isEmpty) {
      cvvError = "Укажите CVV";
      notifyListeners();
      return false;
    }

    cvvError = null;
    notifyListeners();
    return true;
  }

  bool validateCardholder() {
    if (type != TarlanType.payIn && type != TarlanType.cardLink) {
      return true;
    }
    String name = paymentHelper.cardEncryptData.fullName ?? '';
    if (name.isEmpty) {
      cardHolderError = "Необходимо указать имя держателя карты";
      notifyListeners();
      return false;
    }

    cardHolderError = null;
    notifyListeners();
    return true;
  }

  bool validateEmail() {
    String email;
    switch (type) {
      case TarlanType.cardLink:
        email = paymentHelper.payInPostData.userEmail ?? '';
      case TarlanType.payIn:
        email = paymentHelper.payInPostData.userEmail ?? '';
      case TarlanType.payOut:
        email = paymentHelper.payOutPostData.userEmail ?? '';
      case TarlanType.oneClickPayIn:
        email = paymentHelper.oneClickPostData.userEmail ?? '';
      case TarlanType.oneClickPayOut:
        email = paymentHelper.oneClickPostData.userEmail ?? '';
      case TarlanType.unsupported:
        email = paymentHelper.payInPostData.userEmail ?? '';
    }

    if (email.isEmpty && merchantInfo.requiredEmail && merchantInfo.hasEmail) {
      emailError = "Необходимо указать электронный адрес";
      notifyListeners();
      return false;
    }

    if (!Regex.emailRegex.hasMatch(email) && email.isNotEmpty) {
      emailError = "Неверный формат электронного адреса";
      notifyListeners();
      return false;
    }

    emailError = null;
    notifyListeners();
    return true;
  }

  bool validatePhone() {
    String phone;
    switch (type) {
      case TarlanType.cardLink:
        phone = paymentHelper.payInPostData.userPhone ?? '';
      case TarlanType.payIn:
        phone = paymentHelper.payInPostData.userPhone ?? '';
      case TarlanType.payOut:
        phone = paymentHelper.payOutPostData.userPhone ?? '';
      case TarlanType.oneClickPayIn:
        phone = paymentHelper.oneClickPostData.userPhone ?? '';
      case TarlanType.oneClickPayOut:
        phone = paymentHelper.oneClickPostData.userPhone ?? '';
      case TarlanType.unsupported:
        phone = paymentHelper.payInPostData.userPhone ?? '';
    }
    if (phone.isEmpty && merchantInfo.requiredPhone && merchantInfo.hasPhone) {
      phoneError = "Необходимо указать номер телефона";
      notifyListeners();
      return false;
    }

    if (phone.length != 18 && phone.isNotEmpty) {
      phoneError = "Номер телефона указан не полностью";
      notifyListeners();
      return false;
    }

    phoneError = null;
    notifyListeners();
    return true;
  }

  void clearEmailError() {
    emailError = null;
    notifyListeners();
  }

  void clearPhoneError() {
    phoneError = null;
    notifyListeners();
  }

  void clearCardError() {
    cardError = null;
    notifyListeners();
  }

  void clearExpiryError() {
    expiryError = null;
    notifyListeners();
  }

  void clearCvvError() {
    cvvError = null;
    notifyListeners();
  }

  void clearCardHolderError() {
    cardHolderError = null;
    notifyListeners();
  }

  String receiptPdfUrl() {
    final urlData = SessionData().getUrlData();
    final queryParameters = {'hash': urlData?.hash, 'id': urlData?.transactionId, 'locale': 'ru'};
    final uri = Uri.https(ApiClient().baseUrl(ApiType.main), ApiConstants.pathReceiptDownload, queryParameters);
    return uri.toString();
  }

  void deactivateCard(String cardToken) async {
    try {
      final projectIdString = SessionData().getProjectId();
      if (projectIdString != null) {
        final projectId = int.parse(projectIdString);
        paymentHelper.cardDeactivatePostData.encryptedCardId = cardToken;
        paymentHelper.cardDeactivatePostData.projectId = projectId;
        await paymentWebService.deactivateCard(paymentHelper.cardDeactivatePostData);
      }
    } catch (_) {}
  }

  bool hasPhoneEmail() {
    return merchantInfo.hasEmail || merchantInfo.hasPhone;
  }
}
