import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class InfoBattery extends StatelessWidget {
  final String info;
  final IconData? iconData;
  final Color color;

  const InfoBattery({
    super.key,
    required this.info,
    this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: color, size: 14),
        SizedBox(width: 5),
        Text(info, style: TextStyle(color: AppColor.whiteColor, fontSize: 13)),
      ],
    );
  }
}
