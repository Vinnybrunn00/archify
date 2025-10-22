import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class InfoBattery extends StatelessWidget {
  final String info;

  const InfoBattery({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColor.greenColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(width: 8),
        Text(info, style: TextStyle(color: AppColor.whiteColor)),
      ],
    );
  }
}
