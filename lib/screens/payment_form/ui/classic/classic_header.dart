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
            Text(provider.merchantInfo.storeName ?? '',
                style: TextStyle(fontSize: 12, color: HexColor(provider.colorsInfo.mainTextColor ?? '#000000'))),
            Text('${provider.transactionInfo.totalAmount.toString()}₸',
                style: TextStyle(
                    fontSize: 32,
                    color: HexColor(provider.colorsInfo.secondaryTextColor ?? '#000000'),
                    fontWeight: FontWeight.bold)),
            Text('№${provider.transactionInfo.transactionId.toString()}',
                style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor ?? '#000000'))),
          ],
        ),
      ],
    );
  }
}
