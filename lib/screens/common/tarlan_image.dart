import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../network/api_client.dart';
import '../../network/api_type.dart';

class TarlanImage extends StatelessWidget {
  final double width;
  final double height;
  final String url;

  const TarlanImage({
    super.key,
    required this.width,
    required this.height,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _getLogo(url),
    );
  }

  Future<Widget> _loadSvgOrError(String imageUrl) async {
    try {
      final cdnUrl = ApiClient().baseUrl(ApiType.cdn);
      return SvgPicture.network(
        '$cdnUrl$imageUrl',
        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
      );
    } catch (e) {
      return Image.asset('assets/placeholder_logo.png', fit: BoxFit.cover);
    }
  }

  Widget _buildSvgOrError(String url) {
    return FutureBuilder<Widget>(
      future: _loadSvgOrError(url),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Image.asset('assets/placeholder_logo.png', fit: BoxFit.cover);
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Widget _getLogo(String? url) {
    final cdnUrl = ApiClient().baseUrl(ApiType.cdn);
    if (url == null) {
      return Image.asset('assets/placeholder_logo.png', fit: BoxFit.cover);
    } else if (url.endsWith('.svg')) {
      return _buildSvgOrError(url);
    } else {
      return Image.network(
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
          return Image.asset('assets/placeholder_logo.png', fit: BoxFit.cover);
        },
        fit: BoxFit.cover,
      );
    }
  }
}
