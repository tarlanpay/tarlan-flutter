import '/data/model/pay_in/pay_in_response.dart';
import 'error_dialog_type.dart';

abstract class PaymentResultRoute {}

class ThreeDsResultRoute extends PaymentResultRoute {
  ThreeDs threeDs;

  ThreeDsResultRoute({required this.threeDs});
}

class FingerprintResultRoute extends PaymentResultRoute {
  Fingerprint fingerprint;

  FingerprintResultRoute({required this.fingerprint});
}

class ReceiptResultRoute extends PaymentResultRoute {
  ReceiptResultRoute();
}

class SuccessDialogResultRoute extends PaymentResultRoute {
  SuccessDialogResultRoute();
}

class ErrorResultRoute extends PaymentResultRoute {
  ErrorDialogType type;
  String? message;
  ErrorResultRoute({required this.type, this.message});
}
