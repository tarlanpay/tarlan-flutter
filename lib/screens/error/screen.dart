import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/constant.dart';
import '../../data/model/common/session_data.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final Color mainFormColor;

  const ErrorScreen({
    super.key,
    required this.errorMessage,
    required this.mainFormColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            '${Constant.assets}ic_error.svg',
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Транзакция прошла неуспешно',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage.isNotEmpty ? errorMessage : 'An unknown error occurred.',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                SessionData().triggerOnErrorCallback();
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: mainFormColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Назад',
                style: TextStyle(color: mainFormColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '${Constant.assets}mastercard_logo.png',
                fit: BoxFit.cover,
                width: 46,
                height: 15,
              ),
              const SizedBox(width: 8),
              Image.asset(
                '${Constant.assets}visa_logo.png',
                fit: BoxFit.cover,
                width: 46,
                height: 15,
              ),
              const SizedBox(width: 8),
              Image.asset(
                '${Constant.assets}pci_logo.png',
                fit: BoxFit.cover,
                width: 46,
                height: 15,
              ),
              const SizedBox(width: 8),
              Image.asset(
                '${Constant.assets}tarlan_logo.png',
                fit: BoxFit.cover,
                width: 46,
                height: 15,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
