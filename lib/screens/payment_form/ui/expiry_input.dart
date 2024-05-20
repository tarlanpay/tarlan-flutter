import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';

import '../../../utils/hex_color.dart';
import 'label.dart';

class ExpiryInput extends StatefulWidget {
  const ExpiryInput({super.key});

  @override
  State<ExpiryInput> createState() => _ExpiryInputState();
}

class _ExpiryInputState extends State<ExpiryInput> {
  String? value;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          title: 'Срок действия карты:',
          hexColor: provider.colorsInfo.inputLabelColor,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            SizedBox(
                height: 40,
                width: 70,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                  decoration: InputDecoration(
                    fillColor: HexColor(provider.colorsInfo.mainInputColor),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                    isDense: true,
                    hintText: 'MM',
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: ((value) => {provider.setExpiryMonth(value)}),
                )),
            const SizedBox(width: 16),
            SizedBox(
                width: 70,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                  decoration: InputDecoration(
                    fillColor: HexColor(provider.colorsInfo.mainInputColor),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                    isDense: true,
                    hintText: 'YY',
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: ((value) => {provider.setExpiryYear(value)}),
                ))
          ],
        )
      ],
    );
  }
}
