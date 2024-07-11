import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/utils/space.dart';

class LogosRow extends StatelessWidget {
  const LogosRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LogoWidget(assetPath: 'assets/mastercard_logo.svg'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/tarlan_logo.svg'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/visa_logo.svg'),
        SizedBox(width: Space.s),
        _LogoWidget(assetPath: 'assets/pci_logo.svg'),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final String assetPath;

  const _LogoWidget({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      fit: BoxFit.cover,
      width: 52,
      height: 18,
    );
  }
}
