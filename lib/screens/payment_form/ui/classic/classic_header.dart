import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/network/api_client.dart';
import '/network/api_type.dart';

import '../../../../data/constant.dart';
import '../../../../domain/tarlan_provider.dart';
import '../../../../utils/hex_color.dart';

class ClassicHeader extends StatelessWidget {
  const ClassicHeader({super.key});

  Future<Widget> _futureSvgOrError(String? imageUrl) async {
    try {
      final cdnUrl = ApiClient().baseUrl(ApiType.cdn);
      return SvgPicture.network(
        '$cdnUrl$imageUrl',
        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
      );
    } catch (e) {
      return Image.asset('${Constant.assets}placeholder_logo.png', fit: BoxFit.cover);
    }
  }

  Widget getSvgPictureOrErrorWidget(String? url) => FutureBuilder(
        future: _futureSvgOrError(url),
        builder: (BuildContext context, snapshot) => snapshot.hasData ? snapshot.data! : const SizedBox(),
      );

  Widget getLogo(String? url) {
    final cdnUrl = ApiClient().baseUrl(ApiType.cdn);
    return url?.endsWith('.svg') ?? false
        ? getSvgPictureOrErrorWidget(url)
        : Image.network(
            '$cdnUrl$url',
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
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Image.asset('${Constant.assets}placeholder_logo.png', fit: BoxFit.cover);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Row(
      children: <Widget>[
        SizedBox(width: 64, height: 64, child: getLogo(provider.merchantInfo.logoFilePath)),
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
