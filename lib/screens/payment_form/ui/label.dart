import 'package:flutter/material.dart';
import '/utils/hex_color.dart';

class Label extends StatelessWidget {
  final String title;
  final String? hexColor;
  final double? fontSize;

  const Label({super.key, required this.title, this.hexColor, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 10,
        color: hexColor != null ? HexColor(hexColor) : const Color(0xFF555555),
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
      ),
      maxLines: 1, // Adjust as needed
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start, // Adjust as needed
    );
  }
}
