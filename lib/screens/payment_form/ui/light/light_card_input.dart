import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';

import '../../../../utils/card_number_formatter.dart';
import '../../../../utils/hex_color.dart';
import '../cardholder_name_input.dart';
import '../cvv_input.dart';
import '../expiry_input.dart';
import '../label.dart';

class LightCardInput extends StatefulWidget {
  const LightCardInput({super.key});

  @override
  State<StatefulWidget> createState() => _LightCardInputState();
}

class _LightCardInputState extends State<LightCardInput> {
  final TextEditingController _controller = TextEditingController();
  bool _saveChecked = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final cards = provider.transactionInfo.cards;
    var menuItems = cards.map((e) => e.maskedPan).toList();
    if (menuItems.isNotEmpty) {
      _controller.text = menuItems.first;
      menuItems.add('Добавить карту');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(title: 'Номер карты:'),
        SizedBox(
          height: 40,
          child: TextField(
            textAlign: TextAlign.center,
            controller: _controller,
            readOnly: provider.isOneClick(),
            decoration: InputDecoration(
                fillColor: HexColor('#F4F4F4'),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                hintStyle: TextStyle(color: HexColor('#8C8C8C')),
                hintText: "XXXX XXXX XXXX XXXX",
                isDense: true,
                contentPadding: const EdgeInsets.all(5),
                suffixIcon: menuItems.isNotEmpty
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String result) {
                          if (result == 'Добавить карту') {
                            _controller.text = '';
                            provider.switchToRegularPay();
                            provider.notify();
                          } else {
                            _controller.text = result;
                            var selectedCard = cards.firstWhere((element) => element.maskedPan == result);
                            provider.paymentHelper.oneClickPostData.encryptedId = selectedCard.cardToken;
                            provider.switchToOneClick();
                            provider.notify();
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return menuItems.map((String item) {
                            return PopupMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList();
                        })
                    : null),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
              LengthLimitingTextInputFormatter(19),
            ],
            onChanged: ((value) => {provider.setCardNumber(value)}),
          ),
        ),
        const SizedBox(height: 10),
        provider.showDetails()
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ExpiryInput(), CvvInput()],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        provider.showDetails() ? const CardHolderNameInput() : const SizedBox.shrink(),
        provider.showDetails()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Label(title: 'Запомнить карту'),
                  Checkbox(
                    activeColor: Colors.green,
                    onChanged: (newValue) {
                      setState(() {
                        _saveChecked = !_saveChecked;
                      });
                    },
                    value: _saveChecked,
                  )
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
