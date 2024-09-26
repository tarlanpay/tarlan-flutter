import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/data/model/error/form_error_type.dart';

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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          title: appLocalizations.cardHolderName,
          hexColor: provider.colorsInfo.inputLabelColor,
        ),
        const SizedBox(height: 5),
        TextField(
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
            errorText: localisedErrorMessage(provider.cardHolderError, appLocalizations),
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
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
          ),
          onChanged: (value) {
            provider.setCardHolderName(value);
            _validateInput();
            if (value.isNotEmpty && provider.paymentHelper.cardEncryptData.fullName?.isNotEmpty == true) {
              provider.clearCardHolderError();
            }
          },
        )
      ],
    );
  }
}
