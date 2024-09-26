import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/common/session_data.dart';
import '../../utils/space.dart';
import '../common/logos.dart';

class SuccessScreen extends StatelessWidget {
  final Color mainFormColor;

  const SuccessScreen({
    super.key,
    required this.mainFormColor,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xxl, horizontal: Space.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSuccessIcon(),
          const SizedBox(height: Space.l),
          _buildSuccessTitle(appLocalizations.cardLinkedSuccessfully),
          const SizedBox(height: Space.s),
          _buildSuccessMessage(appLocalizations.cardSavedForFutureUse),
          const SizedBox(height: Space.l),
          _buildBackButton(context),
          const SizedBox(height: Space.l),
          const LogosRow(),
          const SizedBox(height: Space.l),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return SvgPicture.asset(
      'assets/ic_success.svg',
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    );
  }

  Widget _buildSuccessTitle(String value) {
    return Text(
      value,
      style: const TextStyle(color: Colors.green, fontSize: 18),
    );
  }

  Widget _buildSuccessMessage(String value) {
    return Text(
      value,
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
          SessionData().triggerOnSuccessCallback();
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
