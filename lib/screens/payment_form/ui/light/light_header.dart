import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';

import '../../../../network/api_client.dart';
import '../../../../network/api_type.dart';
import '../../../../utils/hex_color.dart';

class LightHeader extends StatelessWidget {
  const LightHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final cdnUrl = ApiClient().baseUrl(ApiType.cdn);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
          width: 50,
          child: provider.merchantInfo.logoFilePath.endsWith('.svg') ?? false
              ? SvgPicture.network(
                  '$cdnUrl${provider.merchantInfo.logoFilePath}',
                  placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                )
              : Image.network(
                  '$cdnUrl${provider.merchantInfo.logoFilePath}',
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                ),
        ),
        Text(provider.merchantInfo.storeName,
            style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor ?? '#000000'))),
        Text('${provider.transactionInfo.totalAmount.toString()}₸',
            style: TextStyle(
                fontSize: 24,
                color: HexColor(provider.colorsInfo.secondaryTextColor ?? '#000000'),
                fontWeight: FontWeight.bold)),
        Text('№${provider.transactionInfo.transactionId.toString()}',
            style: TextStyle(fontSize: 11, color: HexColor(provider.colorsInfo.mainTextColor ?? '#000000'))),
      ],
    );
  }
}
