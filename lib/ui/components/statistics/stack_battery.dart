import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class StackBattery extends StatelessWidget {
  final int percent;
  final String charging;

  const StackBattery({
    super.key,
    required this.percent,
    required this.charging,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 550),
          height: percent.toDouble(),
          width: size.width * .09,
          decoration: BoxDecoration(
            color: charging == 'Charging'
                ? AppColor.greenColor.withAlpha(60)
                : AppColor.blackBlue.withAlpha(120),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Positioned(
          top: 40,
          left: percent == 100 ? 8 : 10,
          child: Column(
            children: [
              Text(
                percent.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              charging == 'Charging'
                  ? Icon(EvaIcons.flash, color: AppColor.orangerColor, size: 13)
                  : Container(),
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 550),
          height: 100,
          width: size.width * .09,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.greenColor.withAlpha(200)),
          ),
        ),
      ],
    );
  }
}
