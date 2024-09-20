class ApiConstants {
  static String prodBaseUrl = 'prapi.tarlanpayments.kz';
  static String sandBoxBaseUrl = 'sandboxapi.tarlanpayments.kz';
  static String merchantProdBaseUrl = 'mrapi.tarlanpayments.kz';
  static String merchantSandboxBaseUrl = 'sandboxmrapi.tarlanpayments.kz';
  static String cdnProdBaseUrl = 'https://mrcdn.tarlanpayments.kz/';
  static String cdnSandboxBaseUrl = 'https://mrcdn-sandbox.tarlanpayments.kz/';

  static String pathTransactionInfo = '/transaction/api/v1/transaction';
  static String pathCardLink = '/transaction/api/v1/transaction/card-link';
  static String pathCardDeactivate = '/transaction/api/v1/tokens/deactivate';
  static String pathPayIn = '/transaction/api/v1/transaction/pay-in';
  static String pathPayOut = '/transaction/api/v1/transaction/pay-out';
  static String pathOneClickPayIn = '/transaction/api/v1/transaction/one-click/pay-in';
  static String pathOneClickPayOut = '/transaction/api/v1/transaction/one-click/pay-out';
  static String pathReceipt = '/transaction/api/v1/receipt';
  static String pathReceiptDownload = '/transaction/api/v1/receipt/download';
  static String pathPublicKey = '/card/api/v1/encryption/public-key';
  static String pathResume = '/transaction/api/v1/resume';
}
