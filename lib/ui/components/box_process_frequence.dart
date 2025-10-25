import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxProcessFrequence extends StatelessWidget {
  final int index;
  final double frequence;

  const BoxProcessFrequence({
    super.key,
    required this.index,
    required this.frequence,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 550),
      height: 48,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Núcleo $index',
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$frequence mhz',
            style: TextStyle(color: AppColor.whiteColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
