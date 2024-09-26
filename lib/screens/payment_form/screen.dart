import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/screens/common/logos.dart';
import 'package:tarlan_payments/screens/payment_form/ui/phone_email_input.dart';

import '../../data/model/common/session_data.dart';
import '../../domain/tarlan_provider.dart';
import '../../utils/hex_color.dart';
import '../../utils/space.dart';
import 'ui/classic/classic_card_input.dart';
import 'ui/classic/classic_header.dart';
import 'ui/label.dart';
import 'ui/light/light_header.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool? saveChecked = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarlanProvider>(context);
    return provider.isLoading ? const Center(child: CircularProgressIndicator()) : _buildForm(context, provider);
  }

  Widget _buildForm(BuildContext context, TarlanProvider provider) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(Space.m),
              child: Column(
                children: <Widget>[
                  _buildHeader(provider),
                  const SizedBox(height: Space.l),
                  const ClassicCardInput(),
                  const SizedBox(height: Space.s),
                  provider.showRememberCardOption()
                      ? _buildRememberCardRow(appLocalizations, provider)
                      : const SizedBox(height: Space.s),
                  const SizedBox(height: Space.s),
                  provider.hasPhoneEmail() ? const PhoneEmailInput() : const SizedBox(),
                  const SizedBox(height: Space.s),
                  if (!provider.showDetails()) const SizedBox(height: 24),
                  _buildPayButton(appLocalizations, context, provider),
                  const SizedBox(height: Space.s),
                  _buildCancelButton(appLocalizations, context, provider),
                  const SizedBox(height: Space.l),
                  const LogosRow(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(TarlanProvider provider) {
    return provider.isClassicTheme() ? const ClassicHeader() : const LightHeader();
  }

  Widget _buildRememberCardRow(AppLocalizations appLocalizations, TarlanProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Label(
          title: appLocalizations.rememberCard,
          hexColor: provider.colorsInfo.mainTextColor,
          fontSize: 14,
        ),
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            activeColor: HexColor(provider.colorsInfo.mainFormColor),
            onChanged: (newValue) {
              setState(() {
                saveChecked = newValue;
              });
            },
            value: saveChecked,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton(AppLocalizations appLocalizations, BuildContext context, TarlanProvider provider) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            HexColor(provider.colorsInfo.mainFormColor),
            HexColor(provider.colorsInfo.secondaryFormColor),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          provider.setSaveCard(saveChecked);
          provider.validateForm();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          provider.isCardLink()
              ? appLocalizations.linkCard
              : '${appLocalizations.pay} ${provider.transactionInfo.totalAmount.toString()}₸',
          style: TextStyle(
            color: HexColor(provider.colorsInfo.mainTextInputColor),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(AppLocalizations appLocalizations, BuildContext context, TarlanProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: () {
          SessionData().triggerOnErrorCallback();
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: HexColor(provider.colorsInfo.mainFormColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          appLocalizations.cancel,
          style: TextStyle(
            color: HexColor(provider.colorsInfo.mainFormColor),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
