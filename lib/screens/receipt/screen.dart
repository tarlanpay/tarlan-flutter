import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';
import '/screens/receipt/dashed_line_painter.dart';
import '/utils/hex_color.dart';

import '../../data/model/common/session_data.dart';
import '../payment_form/ui/light/light_header.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final info = provider.receiptInfo;
    return provider.isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              const LightHeader(),
              const SizedBox(height: 30),
              DashedLine(
                color: HexColor('#A4A4A4'),
              ),
              const SizedBox(height: 20),
              receiptRow('Номер заказа', '№${info.transactionId}'),
              const SizedBox(height: 20),
              receiptRow('Сумма оплаты', '${info.totalAmount}${info.currency}'),
              const SizedBox(height: 20),
              receiptRow('Комиссия', '${info.upperCommissionAmount}${info.currency}'),
              const SizedBox(height: 20),
              receiptRow('Название банка-эквайера', info.acquirerName),
              const SizedBox(height: 20),
              receiptRow('Дата транзакции', '${info.dateTime}'),
              const SizedBox(height: 20),
              info.projectName != null ? Text(info.projectName) : const SizedBox.shrink(),
              info.projectName != null ? const SizedBox(height: 20) : const SizedBox.shrink(),
              DashedLine(
                color: HexColor('#A4A4A4'),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(colors: [
                      HexColor(provider.colorsInfo.mainFormColor),
                      HexColor(provider.colorsInfo.secondaryFormColor),
                    ])),
                child: ElevatedButton(
                  onPressed: () {
                    SessionData().triggerOnSuccessCallback();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Вернуться в приложение',
                    style: TextStyle(
                        color: HexColor(provider.colorsInfo.mainTextInputColor),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
  }

  Widget receiptRow(String left, String? right) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style: TextStyle(fontSize: 12, color: HexColor('#555555')),
            ),
            Text(
              right ?? 'Неизвестно',
              style: TextStyle(fontSize: 12, color: HexColor('#B0B0B0')),
            )
          ],
        ),
        DashedLine(
          color: HexColor('#E6E6E6'),
        ),
      ],
    );
  }
}
