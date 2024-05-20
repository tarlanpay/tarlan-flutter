import '../transaction/transaction_info.dart';

enum TarlanType {
  cardLink,
  payIn,
  payOut,
  oneClickPayIn,
  oneClickPayOut,
  unsupported;

  factory TarlanType.fromTransactionInfo(TransactionInfo? info) {
    switch (info?.transactionType.code) {
      case 'card_link':
        return TarlanType.cardLink;
      case 'in':
        return TarlanType.payIn;
      case 'out':
        return TarlanType.payOut;
      case 'one_click_pay_in':
        return TarlanType.oneClickPayIn;
      case 'one_click_pay_out':
        return TarlanType.oneClickPayOut;
    }
    return TarlanType.unsupported;
  }
}
