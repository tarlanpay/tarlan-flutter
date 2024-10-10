import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarlan_payments/utils/hex_color.dart';

import '../../data/model/common/session_data.dart';
import '../../data/model/common/status.dart';
import '../../data/model/common/type.dart';
import '../../utils/space.dart';
import '../common/logos.dart';
import '../receipt/redirect_timer.dart';

class StatusShowScreen extends StatelessWidget {
  final Color mainFormColor;
  final TarlanStatus status;
  final TarlanType type;
  final String transactionId;
  bool hasRedirect;
  int timeout;

  StatusShowScreen({
    super.key,
    required this.mainFormColor,
    required this.status,
    required this.type,
    required this.transactionId,
    required this.hasRedirect,
    required this.timeout,
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
          const SizedBox(height: Space.l),
          _buildStatusIcon(),
          const SizedBox(height: Space.l),
          _buildTitle(appLocalizations),
          const SizedBox(height: Space.s),
          _buildMessage(appLocalizations),
          const SizedBox(height: Space.s),
          _buildTransactionId(appLocalizations),
          const SizedBox(height: Space.s),
          hasRedirect ? RedirectTimer(timeout: timeout, fontSize: 14) : const SizedBox.shrink(),
          const SizedBox(height: Space.l),
          _buildBackButton(context),
          const SizedBox(height: Space.l),
          const LogosRow(),
          const SizedBox(height: Space.l),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    String value;
    switch (status) {
      case TarlanStatus.success:
        value = 'assets/ic_success.svg';
      case TarlanStatus.failed:
        value = 'assets/ic_error.svg';
      case TarlanStatus.error:
        value = 'assets/ic_warning.svg';
      case TarlanStatus.refund:
        value = 'assets/ic_success.svg';
      case TarlanStatus.refundWaiting:
        value = 'assets/ic_success.svg';
      case TarlanStatus.authorized:
        value = 'assets/ic_success.svg';
      case TarlanStatus.canceled:
        value = 'assets/ic_error.svg';
      case TarlanStatus.processed:
        value = 'assets/ic_clock.svg';
      default:
        value = 'assets/ic_warning.svg';
    }
    return SvgPicture.asset(
      value,
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    );
  }

  Widget _buildTitle(AppLocalizations appLocalizations) {
    String value;
    switch (status) {
      case TarlanStatus.success:
        value = appLocalizations.statusSuccessTitle;
      case TarlanStatus.failed:
        value = appLocalizations.statusFailedTitle;
      case TarlanStatus.error:
        value = appLocalizations.statusErrorTitle;
      case TarlanStatus.refund:
        value = appLocalizations.statusRefundTitle;
      case TarlanStatus.refundWaiting:
        value = appLocalizations.statusRefundWaitingTitle;
      case TarlanStatus.authorized:
        value = appLocalizations.statusAuthorizedTitle;
      case TarlanStatus.canceled:
        value = appLocalizations.statusCancelledTitle;
      case TarlanStatus.processed:
        switch (type) {
          case TarlanType.cardLink:
            value = appLocalizations.statusProcessedCardLinkTitle;
          case TarlanType.payIn:
            value = appLocalizations.statusProcessedPayInTitle;
          case TarlanType.payOut:
            value = appLocalizations.statusProcessedPayOutTitle;
          case TarlanType.oneClickPayIn:
            value = appLocalizations.statusProcessedPayInTitle;
          case TarlanType.oneClickPayOut:
            value = appLocalizations.statusProcessedPayOutTitle;
          case TarlanType.unsupported:
            value = appLocalizations.statusErrorTitle;
        }
      default:
        value = appLocalizations.statusErrorTitle;
    }
    return Text(
      value,
      style: TextStyle(color: _getTitleColor(), fontSize: 18),
    );
  }

  Widget _buildMessage(AppLocalizations appLocalizations) {
    String value;
    switch (status) {
      case TarlanStatus.success:
        value = appLocalizations.statusSuccessMessage;
      case TarlanStatus.failed:
        value = appLocalizations.statusFailedMessage;
      case TarlanStatus.error:
        value = appLocalizations.statusErrorMessage;
      case TarlanStatus.refund:
        value = appLocalizations.statusRefundMessage;
      case TarlanStatus.refundWaiting:
        value = appLocalizations.statusRefundWaitingMessage;
      case TarlanStatus.authorized:
        value = appLocalizations.statusAuthorizedMessage;
      case TarlanStatus.canceled:
        value = appLocalizations.statusCancelledMessage;
      case TarlanStatus.processed:
        switch (type) {
          case TarlanType.cardLink:
            value = appLocalizations.statusProcessedCardLinkMessage;
          case TarlanType.payIn:
            value = appLocalizations.statusProcessedPayInMessage;
          case TarlanType.payOut:
            value = appLocalizations.statusProcessedPayOutMessage;
          case TarlanType.oneClickPayIn:
            value = appLocalizations.statusProcessedPayInMessage;
          case TarlanType.oneClickPayOut:
            value = appLocalizations.statusProcessedPayOutMessage;
          case TarlanType.unsupported:
            value = appLocalizations.statusErrorMessage;
        }
      default:
        value = appLocalizations.statusErrorMessage;
    }
    return Text(
      value,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTransactionId(AppLocalizations appLocalizations) {
    return transactionId.isNotEmpty
        ? Text(
            '${appLocalizations.statusTransactionId} $transactionId',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          )
        : const SizedBox.shrink();
  }

  HexColor _getTitleColor() {
    String value;
    switch (status) {
      case TarlanStatus.error:
        value = '#F4A300';
      case TarlanStatus.processed:
        value = '#F4A300';
      default:
        value = '#AAAAAA';
    }
    return HexColor(value);
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
