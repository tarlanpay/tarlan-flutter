import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '/domain/tarlan_provider.dart';

class FingerprintForm extends StatefulWidget {
  const FingerprintForm({super.key});

  @override
  _FingerprintState createState() => _FingerprintState();
}

class _FingerprintState extends State<FingerprintForm> {
  late double _webViewHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _webViewHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final data = provider.fingerprint;

    final String url = data.methodUrl!;
    final String postData = 'method_data=${data.methodData}';

    return SizedBox(
      height: _webViewHeight,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(url)),
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: Uint8List.fromList(utf8.encode(postData)),
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url!;
          if (url.toString().contains('tarlanpayments')) {
            provider.threeDsFinished();
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) {
          provider.resumeFingerprint();
        },
      ),
    );
  }
}
