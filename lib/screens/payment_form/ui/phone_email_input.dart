import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/tarlan_provider.dart';
import '../../../utils/hex_color.dart';
import '../../../utils/space.dart';
import 'label.dart';

class PhoneEmailInput extends StatefulWidget {
  const PhoneEmailInput({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneEmailState();
}

class _PhoneEmailState extends State<PhoneEmailInput> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
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
            title: 'Номер телефона:',
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
          const SizedBox(height: Space.xs),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
            style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
            decoration: InputDecoration(
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
              hintText: "+7 (___) ___ - __ - __",
              hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            onChanged: (value) {
              provider.setUserPhone(value);
            },
          ),
          const SizedBox(height: Space.m),
          Label(
            title: 'Email:',
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
          const SizedBox(height: Space.xs),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
            style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
            decoration: InputDecoration(
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
              hintText: "example@email.com",
              hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            onChanged: (value) {
              provider.setUserPhone(value);
            },
          ),
          const SizedBox(height: Space.m),
        ],
      ),
    );
  }
}
