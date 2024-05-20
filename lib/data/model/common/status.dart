import '../transaction/transaction_info.dart';

enum TarlanStatus {
  newTransaction,
  success,
  failed,
  refund,
  unsupported;

  factory TarlanStatus.fromTransactionInfo(TransactionInfo? info) {
    switch (info?.transactionStatus.code) {
      case 'new':
        return TarlanStatus.newTransaction;
      case 'success':
        return TarlanStatus.success;
      case 'failed':
        return TarlanStatus.failed;
      case 'refund':
        return TarlanStatus.refund;
    }
    return TarlanStatus.unsupported;
  }
}
