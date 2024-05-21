import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarlan_payments/screens/common/logos.dart';

import '../../data/model/common/session_data.dart';
import '../../domain/tarlan_provider.dart';
import '../../utils/hex_color.dart';
import '../../utils/space.dart';
import '../error/screen.dart';
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

    _showErrorModalIfNeeded(context, provider);

    return provider.isLoading ? const Center(child: CircularProgressIndicator()) : _buildForm(context, provider);
  }

  void _showErrorModalIfNeeded(BuildContext context, TarlanProvider provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.error != null) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            isDismissible: true,
            builder: (context) => ErrorScreen(
                  errorMessage: provider.error!.message ?? '',
                  mainFormColor: HexColor(provider.colorsInfo.mainFormColor),
                )).whenComplete(() {
          provider.clearError();
          SessionData().triggerOnErrorCallback();
          Navigator.of(context).pop(); // Example: clear the error in the provider
        });
      }
    });
  }

  Widget _buildForm(BuildContext context, TarlanProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(Space.m),
      child: Column(
        children: <Widget>[
          _buildHeader(provider),
          const SizedBox(height: Space.l),
          const ClassicCardInput(),
          if (provider.showDetails()) _buildRememberCardRow(provider),
          if (!provider.showDetails()) const SizedBox(height: 24),
          _buildPayButton(context, provider),
          const SizedBox(height: Space.s),
          _buildCancelButton(context, provider),
          const SizedBox(height: Space.l),
          const LogosRow(),
          const SizedBox(height: Space.l),
        ],
      ),
    );
  }

  Widget _buildHeader(TarlanProvider provider) {
    return provider.isClassicTheme() ? const ClassicHeader() : const LightHeader();
  }

  Widget _buildRememberCardRow(TarlanProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Label(
          title: 'Запомнить карту',
          hexColor: provider.colorsInfo.mainTextColor,
          fontSize: 14,
        ),
        Checkbox(
          activeColor: HexColor(provider.colorsInfo.mainFormColor),
          onChanged: (newValue) {
            setState(() {
              saveChecked = newValue;
            });
          },
          value: saveChecked,
        ),
      ],
    );
  }

  Widget _buildPayButton(BuildContext context, TarlanProvider provider) {
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
          provider.setMockData();
          provider.setSaveCard(saveChecked);
          provider.makePayment();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          'ОПЛАТИТЬ ${provider.transactionInfo.totalAmount.toString()}₸',
          style: TextStyle(
            color: HexColor(provider.colorsInfo.mainTextInputColor),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, TarlanProvider provider) {
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
          'Отменить',
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
