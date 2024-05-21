import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/upper_text.dart';
import '/domain/tarlan_provider.dart';
import '/utils/hex_color.dart';
import 'label.dart';

class CardHolderNameInput extends StatefulWidget {
  const CardHolderNameInput({super.key});

  @override
  State<StatefulWidget> createState() => _CardHolderNameInputState();
}

class _CardHolderNameInputState extends State<CardHolderNameInput> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          title: 'Имя владельца карты:',
          hexColor: provider.colorsInfo.inputLabelColor,
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
            style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
            decoration: InputDecoration(
              fillColor: HexColor(provider.colorsInfo.mainInputColor),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            inputFormatters: [UpperCaseTextFormatter()],
            onChanged: ((value) => {provider.setCardHolderName(value)}),
          ),
        )
      ],
    );
  }
}
