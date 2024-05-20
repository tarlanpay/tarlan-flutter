import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';

import '../../data/model/common/session_data.dart';

class ThreeDSForm extends StatelessWidget {
  const ThreeDSForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final data = provider.threeDs;
    String buildHiddenInputs() {
      String inputs = '';
      int index = 0;
      int totalParams = data.params!.length;
      for (var param in data.params!.entries) {
        inputs += '${param.key}=${param.value}';
        if (index < totalParams - 1) {
          inputs += '&';
        }
        index++;
      }
      return inputs;
    }

    print("WEBVIEW_3DS_URL: ${data.action}");
    print("WEBVIEW_3DS_POST_DATA: ${buildHiddenInputs()}");

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri.uri(Uri.parse(data.action!)),
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: Uint8List.fromList(utf8.encode(buildHiddenInputs())),
      ),
      onWebViewCreated: (controller) {
        print("WebView Created: ${controller.toString()}");
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url!;
        print('TARLAN_shouldOverrideUrlLoading: ${url.toString()}');
        print('TARLAN_Session_data: ${SessionData().getUrlData()?.rawUrl.toString()}');
        if (url.toString().contains('transaction')) {
          // provider.show3DS = false;
          // provider.showLoading();
          // provider.getReceipt();
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
