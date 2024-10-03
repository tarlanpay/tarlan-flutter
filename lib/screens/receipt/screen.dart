import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tarlan_payments/screens/receipt/receipt_design_constants.dart';
import 'package:tarlan_payments/screens/receipt/receipt_header.dart';
import 'package:tarlan_payments/screens/receipt/redirect_timer.dart';

import '/data/model/common/session_data.dart';
import '/domain/tarlan_provider.dart';
import '/screens/receipt/dashed_line_painter.dart';
import '/utils/hex_color.dart';
import '/utils/space.dart';
import '../common/logos.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  String? savePdfTitle;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(Space.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Space.xxl),
                const ReceiptHeader(),
                const SizedBox(height: Space.xl),
                DashedLine(color: HexColor('#A4A4A4')),
                const SizedBox(height: Space.l),
                _buildReceiptRow(
                    appLocalizations, appLocalizations.orderNumber, '№${provider.receiptInfo.transactionId}'),
                _buildReceiptRow(appLocalizations, appLocalizations.paymentAmount,
                    '${provider.receiptInfo.orderAmount}${provider.receiptInfo.currency}'),
                _buildReceiptRow(appLocalizations, appLocalizations.merchant, provider.merchantInfo.storeName),
                _buildReceiptRow(appLocalizations, appLocalizations.acquirerBank, provider.receiptInfo.acquirerName),
                provider.receiptInfo.email.isNotEmpty
                    ? _buildReceiptRow(appLocalizations, 'Email', provider.receiptInfo.email)
                    : const SizedBox.shrink(),
                provider.receiptInfo.phone.isNotEmpty
                    ? _buildReceiptRow(appLocalizations, appLocalizations.phoneNumber, provider.receiptInfo.phone)
                    : const SizedBox.shrink(),
                _buildReceiptRow(
                    appLocalizations, appLocalizations.transactionDate, '${provider.receiptInfo.dateTime}'),
                _buildReceiptRow(appLocalizations, appLocalizations.fee,
                    '${provider.receiptInfo.upperCommissionAmount}${provider.receiptInfo.currency}'),
                _buildReceiptRow(appLocalizations, appLocalizations.type, provider.receiptInfo.transactionType),
                Center(
                  child: Text(
                    provider.receiptInfo.paymentOrganization,
                    style: TextStyle(fontSize: 12, color: ReceiptDS.additionalTextColor),
                  ),
                ),
                const SizedBox(height: Space.l),
                DashedLine(color: HexColor('#A4A4A4')),
                const SizedBox(height: Space.l),
                _buildOutlinedButton(
                  context,
                  savePdfTitle ?? appLocalizations.saveReceipt,
                  () {
                    FileDownloader.downloadFile(
                        url: provider.receiptPdfUrl(),
                        name: '${provider.receiptInfo.transactionId.toString()}.pdf',
                        onProgress: (fileName, progress) {
                          setState(() {
                            savePdfTitle = appLocalizations.loadingReceipt;
                          });
                        },
                        onDownloadCompleted: (String path) {
                          share(appLocalizations, path);
                          setState(() {
                            savePdfTitle = appLocalizations.saveReceipt;
                          });
                        },
                        onDownloadError: (String error) {
                          setState(() {
                            savePdfTitle = appLocalizations.errorLoadingReceipt;
                          });
                        });
                  },
                ),
                const SizedBox(height: Space.m),
                _buildOutlinedButton(
                  context,
                  appLocalizations.back,
                  () {
                    SessionData().triggerOnErrorCallback();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: Space.s),
                provider.merchantInfo.hasRedirect
                    ? RedirectTimer(timeout: provider.merchantInfo.timeout)
                    : const SizedBox.shrink(),
                const LogosRow(),
              ],
            ),
          );
  }

  void share(AppLocalizations appLocalizations, String path) async {
    await Share.shareXFiles([XFile(path)], text: appLocalizations.receipt);
  }

  Widget _buildReceiptRow(AppLocalizations appLocalizations, String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.m),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: ReceiptDS.additionalTextColor),
                  ),
                  Text(
                    value ?? appLocalizations.unknown,
                    style: TextStyle(fontSize: 12, color: ReceiptDS.secondaryTextColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildDashedLine(),
        const SizedBox(height: Space.m),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.m),
      child: DashedLine(color: HexColor('#E6E6E6')),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, String? text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.m),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: ReceiptDS.gradientStartColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Text(
            text ?? '',
            style: TextStyle(
              color: ReceiptDS.gradientStartColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
