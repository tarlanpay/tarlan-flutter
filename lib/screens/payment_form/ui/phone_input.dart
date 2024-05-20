import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/domain/tarlan_provider.dart';
import '/utils/hex_color.dart';

import '../../../utils/upper_text.dart';
import 'label.dart';

class PhoneInput extends StatefulWidget {
  const PhoneInput({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(title: 'Номер телефона:'),
        SizedBox(
          height: 40,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: HexColor('#F4F4F4'),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
              hintStyle: TextStyle(color: HexColor('#8C8C8C')),
              hintText: "+7 123 456 78 90",
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            inputFormatters: [UpperCaseTextFormatter()],
            onChanged: ((value) => {provider.paymentHelper.payInPostData.fullName = value, provider.notify()}),
          ),
        )
      ],
    );
  }
}
