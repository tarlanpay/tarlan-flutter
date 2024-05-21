import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/transaction/transaction_info.dart';
import '../../../../domain/tarlan_provider.dart';
import '../../../../utils/card_number_formatter.dart';
import '../../../../utils/hex_color.dart';
import '../../../../utils/space.dart';
import '../card_picker.dart';
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
  late TextEditingController _controller;
  static const double inputHeight = 40.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TarlanProvider>(context, listen: false);
    final cards = provider.transactionInfo.cards;

    // Initialize the TextEditingController with the maskedPan of the first TransactionCard if available
    _controller = TextEditingController(
      text: cards.isNotEmpty ? cards.first.maskedPan : '',
    );
  }

  List<String> _getMenuItems(TarlanProvider provider) {
    return provider.transactionInfo.cards.map((e) => e.maskedPan).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final menuItems = _getMenuItems(provider);
    final cards = provider.transactionInfo.cards;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            HexColor(provider.colorsInfo.mainFormColor),
            HexColor(provider.colorsInfo.secondaryFormColor),
          ],
        ),
      ),
      padding: const EdgeInsets.all(Space.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            title: 'Номер карты:',
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
          const SizedBox(height: Space.xs),
          _buildCardNumberInput(provider, menuItems, cards),
          if (provider.showDetails()) ...[
            const SizedBox(height: Space.m),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ExpiryInput(), CvvInput()],
            ),
            const SizedBox(height: Space.m),
            const CardHolderNameInput(),
          ],
        ],
      ),
    );
  }

  Widget _buildCardNumberInput(TarlanProvider provider, List<String> menuItems, List<TransactionCard> cards) {
    return SizedBox(
      height: inputHeight,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _controller,
        style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
        readOnly: provider.isOneClick(),
        decoration: InputDecoration(
          fillColor: HexColor(provider.colorsInfo.mainInputColor),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
          hintText: "XXXX XXXX XXXX XXXX",
          isDense: true,
          contentPadding: const EdgeInsets.all(Space.xs),
          suffixIcon: menuItems.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // Ensure the icon is visible
                  onPressed: () => _showCardSelectionSheet(context, provider, menuItems, cards),
                )
              : null,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardNumberFormatter(),
          LengthLimitingTextInputFormatter(19),
        ],
        onChanged: provider.setCardNumber,
      ),
    );
  }

  void _showCardSelectionSheet(
      BuildContext context, TarlanProvider provider, List<String> menuItems, List<TransactionCard> cards) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CardPicker(
          menuItems: menuItems,
          cards: cards,
          controller: _controller,
          provider: provider,
        );
      },
    );
  }
}
