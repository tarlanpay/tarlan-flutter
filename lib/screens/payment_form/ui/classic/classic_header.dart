import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/screens/common/tarlan_image.dart';

import '../../../../domain/tarlan_provider.dart';
import '../../../../utils/hex_color.dart';

class ClassicHeader extends StatelessWidget {
  const ClassicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Row(
      children: <Widget>[
        TarlanImage(width: 64, height: 64, url: provider.merchantInfo.logoFilePath),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider.merchantInfo.storeName,
                style: TextStyle(fontSize: 12, color: HexColor(provider.colorsInfo.mainTextColor))),
            Text(
                provider.isCardLink()
                    ? '${provider.transactionInfo.orderAmount.toString()}₸'
                    : '${provider.transactionInfo.totalAmount.toString()}₸',
                style: TextStyle(
                    fontSize: 32,
                    color: HexColor(provider.colorsInfo.secondaryTextColor),
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text('№${provider.transactionInfo.transactionId.toString()}',
                    style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor))),
                const SizedBox(width: 20),
                provider.isCardLink()
                    ? const SizedBox()
                    : Text('Комиссия ${provider.transactionInfo.upperCommissionAmount.toString()}KZT',
                        style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor))),
              ],
            )
          ],
        ),
      ],
    );
  }
}
