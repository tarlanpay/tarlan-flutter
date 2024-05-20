import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';

import '../../../utils/hex_color.dart';
import 'label.dart';

class CvvInput extends StatefulWidget {
  const CvvInput({super.key});

  @override
  State<StatefulWidget> createState() => _CvvState();
}

class _CvvState extends State<CvvInput> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          title: 'CVV:',
          hexColor: provider.colorsInfo.inputLabelColor,
        ),
        const SizedBox(height: 5),
        SizedBox(
            width: 70,
            height: 40,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
              decoration: InputDecoration(
                fillColor: HexColor(provider.colorsInfo.mainInputColor),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                isDense: true,
                contentPadding: const EdgeInsets.all(5),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: ((value) => {provider.setCVV(value)}),
            ))
      ],
    );
  }
}
