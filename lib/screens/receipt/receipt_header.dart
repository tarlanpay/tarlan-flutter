import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/screens/receipt/receipt_design_constants.dart';

import '../../../../utils/space.dart';
import '../common/tarlan_image.dart';
import '/domain/tarlan_provider.dart';

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final merchantInfo = provider.merchantInfo;
    final transactionInfo = provider.transactionInfo;

    return Column(
      children: <Widget>[
        TarlanImage(width: 50, height: 50, url: merchantInfo.logoFilePath),
        const SizedBox(height: Space.xs),
        Text(
          merchantInfo.storeName,
          style: TextStyle(
            fontSize: 12,
            color: ReceiptDS.additionalTextColor,
          ),
        ),
        Text(
          '${transactionInfo.totalAmount.toString()}₸',
          style: TextStyle(
            fontSize: 32,
            color: ReceiptDS.gradientStartColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
