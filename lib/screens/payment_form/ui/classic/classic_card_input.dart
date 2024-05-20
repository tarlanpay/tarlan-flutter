import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../domain/tarlan_provider.dart';
import '../../../../utils/card_number_formatter.dart';
import '../../../../utils/hex_color.dart';
import '../cardholder_name_input.dart';
import '../cvv_input.dart';
import '../expiry_input.dart';
import '../label.dart';

class ClassicCardInput extends StatefulWidget {
  const ClassicCardInput({super.key});

  @override
  State<StatefulWidget> createState() => _ClassicCardInputState();
}

class _ClassicCardInputState extends State<ClassicCardInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final cards = provider.transactionInfo.cards;
    var menuItems = cards.map((e) => e.maskedPan).toList();
    if (menuItems.isNotEmpty) {
      menuItems.add('Добавить карту');
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
            HexColor(provider.colorsInfo.mainFormColor),
            HexColor(provider.colorsInfo.secondaryFormColor),
          ])),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            title: 'Номер карты:',
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _controller,
              style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
              readOnly: provider.isOneClick(),
              decoration: InputDecoration(
                  fillColor: HexColor(provider.colorsInfo.mainInputColor),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                  hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
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
                              provider.setOneClickCardToken(selectedCard.cardToken);
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
          provider.showDetails() ? const SizedBox(height: 10) : const SizedBox.shrink(),
          provider.showDetails()
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ExpiryInput(), CvvInput()],
                )
              : const SizedBox.shrink(),
          provider.showDetails() ? const SizedBox(height: 10) : const SizedBox.shrink(),
          provider.showDetails() ? const CardHolderNameInput() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
