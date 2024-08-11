import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InfoBox extends StatelessWidget {
  InfoBox({
    super.key,
    required this.label,
    required this.icon,
    required this.info,
    required this.textColor,
    required this.fontSize,
  });
  String? label;
  String? icon;
  String? info;
  Color textColor;
  double fontSize;

  String? truncateWithEllipsis(String? text, int maxLength) {
    if (text != null) {
      if (text.length <= maxLength) {
        return text;
      }
      return '${text.substring(0, maxLength)}...';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            label ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            icon ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            truncateWithEllipsis(info, 30) ?? '',
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
