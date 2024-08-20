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
  String? _localError;

  final _cardNumberFocus = FocusNode();
  final _expiryMonthFocus = FocusNode();
  final _expiryYearFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _cardHolderNameFocus = FocusNode();

  @override
  void dispose() {
    _cardNumberFocus.dispose();
    _expiryMonthFocus.dispose();
    _expiryYearFocus.dispose();
    _cvvFocus.dispose();
    _cardHolderNameFocus.dispose();

    super.dispose();
  }

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

  void _validateCardNumber(String value) {
    setState(() {
      bool isFilled = value.length == 19;
      if (isFilled) {
        bool basicValidation = RegExp(r'^\d{4} \d{4} \d{4} \d{4}$').hasMatch(value);
        bool luhnValidity = checkLuhnValidity(value.replaceAll(" ", ''));
        if (!basicValidation || !luhnValidity) {
          _localError = 'Такой карты не существует';
        } else {
          _localError = null;
        }
      }

      if (_localError == null && isFilled) {
        _expiryMonthFocus.requestFocus();
      }
    });
  }

  bool checkLuhnValidity(String ccNum) {
    int sum = 0;
    bool alternate = false;

    for (int i = ccNum.length - 1; i >= 0; i--) {
      int digit = int.parse(ccNum[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;

      alternate = !alternate;
    }

    return sum % 10 == 0;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ExpiryInput(
                  monthFocusNode: _expiryMonthFocus,
                  yearFocusNode: _expiryYearFocus,
                  nextFocusNode: _cvvFocus,
                ),
                CvvInput(
                  focusNode: _cvvFocus,
                  nextFocusNode: _cardHolderNameFocus,
                ),
              ],
            ),
            const SizedBox(height: Space.m),
            CardHolderNameInput(
              focusNode: _cardHolderNameFocus,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardNumberInput(TarlanProvider provider, List<String> menuItems, List<TransactionCard> cards) {
    return TextField(
      textAlign: TextAlign.center,
      focusNode: _cardNumberFocus,
      controller: _controller,
      autofocus: true,
      cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
      keyboardType: TextInputType.number,
      style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
      readOnly: provider.isOneClick(),
      decoration: InputDecoration(
        fillColor: HexColor(provider.colorsInfo.mainInputColor),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
        errorText: _localError ?? provider.cardError,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(Space.xs),
        suffixIcon: menuItems.isNotEmpty && !provider.isCardLink()
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
      onChanged: (value) {
        provider.setCardNumber(value.trim());
        if (value.isNotEmpty && provider.paymentHelper.cardEncryptData.pan?.isNotEmpty == true) {
          provider.clearCardError();
          _localError = null;
        }
        _validateCardNumber(value);
      },
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
