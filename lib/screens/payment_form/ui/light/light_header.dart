import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/hex_color.dart';
import '../../../../utils/space.dart';
import '../../../common/tarlan_image.dart';
import '/domain/tarlan_provider.dart';

class LightHeader extends StatelessWidget {
  const LightHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Column(
      children: <Widget>[
        TarlanImage(width: 50, height: 50, url: provider.merchantInfo.logoFilePath),
        const SizedBox(
          height: Space.xs,
        ),
        Text(provider.merchantInfo.storeName,
            style: TextStyle(fontSize: 12, color: HexColor(provider.colorsInfo.mainTextColor))),
        Text('${provider.transactionInfo.totalAmount.toString()}₸',
            style: TextStyle(fontSize: 32, color: HexColor('#2073D4'), fontWeight: FontWeight.bold)),
        Text('№${provider.transactionInfo.transactionId.toString()}',
            style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor))),
      ],
    );
  }
}
