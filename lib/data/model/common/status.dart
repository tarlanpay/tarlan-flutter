import '../transaction/transaction_info.dart';

enum TarlanStatus {
  newTransaction,
  success,
  failed,
  error,
  refund,
  refundWaiting,
  authorized,
  canceled,
  processed,
  unsupported;

  factory TarlanStatus.fromTransactionInfo(TransactionInfo? info) {
    switch (info?.transactionStatus.code) {
      case 'new':
        return TarlanStatus.newTransaction;
      case 'success':
        return TarlanStatus.success;
      case 'failed':
        return TarlanStatus.failed;
      case 'error':
        return TarlanStatus.error;
      case 'refund':
        return TarlanStatus.refund;
      case 'processed':
        return TarlanStatus.processed;
      case 'canceled':
        return TarlanStatus.canceled;
      case 'authorized':
        return TarlanStatus.authorized;
      case 'refund_waiting':
        return TarlanStatus.refundWaiting;
    }
    return TarlanStatus.unsupported;
  }
}
