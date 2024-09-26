import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/domain/tarlan_provider.dart';
import '../../../data/model/error/form_error_type.dart';
import '../../../utils/hex_color.dart';
import 'label.dart';

class ExpiryInput extends StatefulWidget {
  final FocusNode monthFocusNode;
  final FocusNode yearFocusNode;
  final FocusNode nextFocusNode;

  const ExpiryInput({
    super.key,
    required this.monthFocusNode,
    required this.yearFocusNode,
    required this.nextFocusNode,
  });

  @override
  State<ExpiryInput> createState() => _ExpiryInputState();
}

class _ExpiryInputState extends State<ExpiryInput> {
  String? value;
  bool _monthError = false;
  bool _yearError = false;

  void _validateMonth(String value) {
    setState(() {
      int intValue = int.parse(value);
      _monthError = intValue > 12 && value.length == 2;
      if (!_monthError && value.length == 2) {
        widget.yearFocusNode.requestFocus();
      }
    });
  }

  void _validateYear(String value) {
    setState(() {
      int currentYear = int.parse(DateTime.now().year.toString().substring(2));
      _yearError = int.parse(value) < currentYear && value.length == 2;
      if (!_yearError && value.length == 2) {
        widget.nextFocusNode.requestFocus();
      }
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
          title: appLocalizations.cardExpiry,
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
                  keyboardType: TextInputType.number,
                  focusNode: widget.monthFocusNode,
                  cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
                  style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                  decoration: InputDecoration(
                    fillColor: HexColor(provider.colorsInfo.mainInputColor),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: _monthError ? Colors.red : Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: _monthError ? Colors.red : Colors.white,
                        width: 1.0,
                      ),
                    ),
                    hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                    isDense: true,
                    hintText: 'MM',
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (value) {
                    provider.setExpiryMonth(value);
                    _validateMonth(value);
                    if (value.isNotEmpty && provider.paymentHelper.cardEncryptData.month?.isNotEmpty == true) {
                      provider.clearExpiryError();
                    }
                  },
                )),
            const SizedBox(width: 16),
            SizedBox(
                width: 70,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  focusNode: widget.yearFocusNode,
                  keyboardType: TextInputType.number,
                  cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
                  style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                  decoration: InputDecoration(
                    fillColor: HexColor(provider.colorsInfo.mainInputColor),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: _yearError ? Colors.red : Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: _yearError ? Colors.red : Colors.white,
                        width: 1.0,
                      ),
                    ),
                    hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
                    isDense: true,
                    hintText: 'YY',
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (value) {
                    provider.setExpiryYear(value);
                    _validateYear(value);
                    if (value.isNotEmpty && provider.paymentHelper.cardEncryptData.year?.isNotEmpty == true) {
                      provider.clearExpiryError();
                    }
                  },
                ))
          ],
        ),
        _yearError || _monthError || provider.expiryError != null
            ? Text(
                localisedErrorMessage(provider.expiryError, appLocalizations) ?? appLocalizations.invalidCardExpiry,
                style: TextStyle(color: Colors.red[900], fontSize: 11),
              )
            : const SizedBox(),
      ],
    );
  }
}
