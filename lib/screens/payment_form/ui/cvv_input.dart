import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/domain/tarlan_provider.dart';
import '../../../data/model/error/form_error_type.dart';
import '../../../utils/hex_color.dart';
import 'label.dart';

class CvvInput extends StatefulWidget {
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const CvvInput({super.key, required this.focusNode, required this.nextFocusNode});

  @override
  State<StatefulWidget> createState() => _CvvState();
}

class _CvvState extends State<CvvInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
            obscureText: true,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.number,
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
              hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
              isDense: true,
              contentPadding: const EdgeInsets.all(5),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onChanged: (value) {
              provider.setCVV(value);
              if (value.isNotEmpty && provider.paymentHelper.cardEncryptData.cvc?.isNotEmpty == true) {
                provider.clearCvvError();
              }
              if (value.length == 3) widget.nextFocusNode.requestFocus();
            },
          ),
        ),
        provider.cvvError != null
            ? Text(
                localisedErrorMessage(provider.cvvError, appLocalizations) ?? appLocalizations.invalidCvv,
                style: TextStyle(color: Colors.red[900], fontSize: 11),
              )
            : const SizedBox(),
      ],
    );
  }
}
