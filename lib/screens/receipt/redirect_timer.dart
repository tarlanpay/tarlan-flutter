import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tarlan_payments/screens/receipt/receipt_design_constants.dart';

import '../../utils/space.dart';

class RedirectTimer extends StatefulWidget {
  final int timeout;

  const RedirectTimer({super.key, required this.timeout});

  @override
  _RedirectTimerState createState() => _RedirectTimerState();
}

class _RedirectTimerState extends State<RedirectTimer> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timeout;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 1) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.m),
          child: Text(
            appLocalizations.returnToStoreInSeconds(_remainingTime),
            style: TextStyle(fontSize: 12, color: ReceiptDS.additionalTextColor),
          ),
        ),
        const SizedBox(height: Space.s),
      ],
    );
  }
}
