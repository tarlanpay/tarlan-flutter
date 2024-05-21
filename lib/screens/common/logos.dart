import 'package:flutter/material.dart';

import '/utils/space.dart';

class LogosRow extends StatelessWidget {
  const LogosRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LogoWidget(assetPath: 'assets/mastercard_logo.png'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/visa_logo.png'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/pci_logo.png'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/tarlan_logo.png'),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final String assetPath;

  const _LogoWidget({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: 46,
      height: 15,
    );
  }
}
