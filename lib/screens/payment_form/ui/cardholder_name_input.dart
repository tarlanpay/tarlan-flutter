import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/domain/tarlan_provider.dart';
import '/utils/hex_color.dart';
import '../../../utils/upper_text.dart';
import 'label.dart';

class CardHolderNameInput extends StatefulWidget {
  final FocusNode focusNode;
  const CardHolderNameInput({super.key, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _CardHolderNameInputState();
}

class _CardHolderNameInputState extends State<CardHolderNameInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;

  void _validateInput() {
    setState(() {
      _hasError = _controller.text.isEmpty;
    });
  }

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
            focusNode: widget.focusNode,
            maxLength: 23,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), UpperCaseTextFormatter()],
            cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
            style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
            decoration: InputDecoration(
              counterText: '',
              fillColor: HexColor(provider.colorsInfo.mainInputColor),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            onChanged: (value) {
              provider.setCardHolderName(value);
              _validateInput();
            },
          ),
        )
      ],
    );
  }
}
