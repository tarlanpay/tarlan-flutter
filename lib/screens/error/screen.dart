import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/common/session_data.dart';
import '../../utils/space.dart';
import '../common/logos.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final Color mainFormColor;

  const ErrorScreen({
    super.key,
    required this.errorMessage,
    required this.mainFormColor,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Space.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorIcon(),
          const SizedBox(height: Space.l),
          _buildErrorTitle(appLocalizations.transactionFailed),
          const SizedBox(height: Space.s),
          _buildErrorMessage(appLocalizations),
          const SizedBox(height: Space.l),
          _buildBackButton(context),
          const SizedBox(height: Space.l),
          const LogosRow(),
          const SizedBox(height: Space.l),
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    return SvgPicture.asset(
      'assets/ic_error.svg',
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    );
  }

  Widget _buildErrorTitle(String value) {
    return Text(
      value,
      style: const TextStyle(color: Colors.red, fontSize: 18),
    );
  }

  Widget _buildErrorMessage(AppLocalizations appLocalizations) {
    return Text(
      errorMessage.isNotEmpty ? errorMessage : appLocalizations.unknownErrorOccurred,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: () {
          SessionData().triggerOnErrorCallback();
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: mainFormColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.back,
          style: TextStyle(color: mainFormColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
