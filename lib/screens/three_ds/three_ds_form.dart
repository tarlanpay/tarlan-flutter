import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '/domain/tarlan_provider.dart';

class ThreeDSForm extends StatefulWidget {
  const ThreeDSForm({super.key});

  @override
  _ThreeDSFormState createState() => _ThreeDSFormState();
}

class _ThreeDSFormState extends State<ThreeDSForm> {
  late double _webViewHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _webViewHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final data = provider.threeDs;

    String buildHiddenInputs() {
      return data.params!.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    }

    final String url = data.action!;
    final String postData = buildHiddenInputs();

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
      ),
    );
  }
}
