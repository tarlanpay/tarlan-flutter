import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/screens/payment_form/fingerprint/fingerprint_form.dart';
import 'package:tarlan_payments/screens/status_show/screen.dart';

import '/domain/tarlan_provider.dart';
import '/screens/receipt/screen.dart';
import '/screens/three_ds/three_ds_form.dart';
import '../domain/flow.dart';
import '../utils/hex_color.dart';
import 'payment_form/screen.dart';

class TarlanParentWidget extends StatelessWidget {
  const TarlanParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TarlanProvider()..load(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: TarlanMainWidget(),
        ),
      ),
    );
  }
}

class TarlanMainWidget extends StatelessWidget {
  const TarlanMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    switch (provider.currentFlow) {
      case TarlanFlow.form:
        return const PaymentForm();
      case TarlanFlow.threeDs:
        return const ThreeDSForm();
      case TarlanFlow.fingerprint:
        return const FingerprintForm();
      case TarlanFlow.receipt:
        return const Receipt();
      case TarlanFlow.statusShow:
        return StatusShowScreen(
          mainFormColor: HexColor(provider.colorsInfo.mainFormColor),
          status: provider.status,
          type: provider.type,
          transactionId: provider.transactionInfo.transactionId.toString(),
          hasRedirect: provider.merchantInfo.hasRedirect,
          timeout: provider.merchantInfo.timeout,
        );
    }
  }
}
