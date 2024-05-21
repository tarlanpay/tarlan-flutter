import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tarlan_payments/screens/receipt/receipt_design_constants.dart';
import 'package:tarlan_payments/screens/receipt/receipt_header.dart';

import '../common/logos.dart';
import '/data/model/common/session_data.dart';
import '/domain/tarlan_provider.dart';
import '/screens/receipt/dashed_line_painter.dart';
import '/utils/hex_color.dart';
import '/utils/space.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  String? savePdfTitle;

  @override
  void initState() {
    super.initState();
    savePdfTitle = 'Сохранить квитанцию';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final info = provider.receiptInfo;
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
                _buildReceiptRow(context, 'Номер заказа', '№${info.transactionId}'),
                _buildDashedLine(),
                const SizedBox(height: Space.m),
                _buildReceiptRow(context, 'Сумма оплаты', '${info.totalAmount}${info.currency}'),
                _buildDashedLine(),
                const SizedBox(height: Space.m),
                _buildReceiptRow(context, 'Комиссия', '${info.upperCommissionAmount}${info.currency}'),
                _buildDashedLine(),
                const SizedBox(height: Space.m),
                _buildReceiptRow(context, 'Дата транзакции', '${info.dateTime}'),
                _buildDashedLine(),
                const SizedBox(height: Space.m),
                _buildReceiptRow(context, 'Банк-эквайер', info.acquirerName),
                _buildDashedLine(),
                const SizedBox(height: Space.m),
                Center(
                  child: Text(
                    info.projectName,
                    style: TextStyle(fontSize: 12, color: ReceiptDS.additionalTextColor),
                  ),
                ),
                const SizedBox(height: Space.l),
                DashedLine(color: HexColor('#A4A4A4')),
                const SizedBox(height: Space.l),
                _buildOutlinedButton(
                  context,
                  savePdfTitle,
                  () {
                    FileDownloader.downloadFile(
                        url: provider.receiptPdfUrl(),
                        name: '${info.transactionId.toString()}.pdf',
                        onProgress: (fileName, progress) {
                          setState(() {
                            savePdfTitle = 'Загрузка квитанции...';
                          });
                        },
                        onDownloadCompleted: (String path) {
                          share(path);
                          setState(() {
                            savePdfTitle = 'Сохранить квитанцию';
                          });
                        },
                        onDownloadError: (String error) {
                          setState(() {
                            savePdfTitle = 'Ошибка загрузки квитанции';
                          });
                        });
                  },
                ),
                const SizedBox(height: Space.m),
                _buildOutlinedButton(
                  context,
                  'Назад',
                  () {
                    SessionData().triggerOnErrorCallback();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: Space.l),
                const LogosRow(),
              ],
            ),
          );
  }

  void share(String path) async {
    await Share.shareXFiles([XFile(path)], text: 'Квитанция');
  }

  Widget _buildReceiptRow(BuildContext context, String label, String? value) {
    return Padding(
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
                value ?? 'Неизвестно',
                style: TextStyle(fontSize: 12, color: ReceiptDS.secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
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
