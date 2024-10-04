import '../transaction/transaction_info.dart';

enum TarlanStatus {
  newTransaction,
  success,
  failed,
  refund,
  unsupported,
  cardProcessing;

  factory TarlanStatus.fromTransactionInfo(TransactionInfo? info) {
    switch (info?.transactionStatus.code) {
      case 'new':
        return TarlanStatus.newTransaction;
      case 'success':
        return TarlanStatus.success;
      case 'failed':
        return TarlanStatus.failed;
      case 'error':
        return TarlanStatus.failed;
      case 'refund':
        return TarlanStatus.refund;
      case 'processed':
        return TarlanStatus.cardProcessing;
    }
    return TarlanStatus.unsupported;
  }
}
