import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../../data/model/error/form_error_type.dart';
import '../../../domain/tarlan_provider.dart';
import '../../../domain/validators/regex.dart';
import '../../../utils/hex_color.dart';
import '../../../utils/space.dart';
import 'label.dart';

class PhoneEmailInput extends StatefulWidget {
  const PhoneEmailInput({super.key});

  @override
  State<StatefulWidget> createState() => _PhoneEmailState();
}

class _PhoneEmailState extends State<PhoneEmailInput> {
  final maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  String? _emailError;

  void validateEmail(AppLocalizations appLocalizations, String email) {
    setState(() {
      if (email.isEmpty) {
        _emailError = null;
        return;
      } else if (!Regex.emailRegex.hasMatch(email)) {
        _emailError = appLocalizations.invalidEmailFormat;
      } else {
        _emailError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
          provider.merchantInfo.hasPhone ? _buildPhone(appLocalizations, provider) : const SizedBox(),
          provider.merchantInfo.hasEmail ? _buildEmail(appLocalizations, provider) : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildEmail(AppLocalizations appLocalizations, TarlanProvider provider) {
    return Column(
      children: [
        Row(children: [
          provider.merchantInfo.requiredEmail
              ? const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox(),
          Label(
            title: 'Email:',
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
        ]),
        const SizedBox(height: Space.xs),
        TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          cursorColor: HexColor(provider.colorsInfo.mainTextInputColor),
          style: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
          decoration: InputDecoration(
            fillColor: HexColor(provider.colorsInfo.mainInputColor),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide.none),
            errorText: _emailError ?? localisedErrorMessage(provider.emailError, appLocalizations),
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
            hintText: "example@email.com",
            hintStyle: TextStyle(color: HexColor(provider.colorsInfo.mainTextInputColor)),
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
          ),
          onChanged: (value) {
            String email = value.trim();
            provider.setUserEmail(email);
            if (email.isNotEmpty && provider.emailError != null) {
              provider.clearEmailError();
            }
            validateEmail(appLocalizations, email);
          },
        ),
        const SizedBox(height: Space.m),
      ],
    );
  }

  Widget _buildPhone(AppLocalizations appLocalizations, TarlanProvider provider) {
    return Column(
      children: [
        Row(children: [
          provider.merchantInfo.requiredPhone
              ? const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox(),
          Label(
            title: appLocalizations.phoneNumber,
            hexColor: provider.colorsInfo.inputLabelColor,
          ),
        ]),
        const SizedBox(height: Space.xs),
        TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.phone,
          inputFormatters: [maskFormatter],
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
            errorText: localisedErrorMessage(provider.phoneError, appLocalizations),
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
          ),
          onChanged: (value) {
            provider.setUserPhone(value);
            if (value.isNotEmpty && provider.phoneError != null) {
              provider.clearPhoneError();
            }
          },
        ),
        const SizedBox(height: Space.m),
      ],
    );
  }
}
