import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class StackBattery extends StatelessWidget {
  final int percent;

  const StackBattery({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 550),
          height: percent.toDouble() * .5,
          width: size.width * .15,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(percent.toString()),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 550),
          height: size.height * .25,
          width: size.width * .15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.greenColor),
          ),
          child: Text(percent.toString()),
        ),
      ],
    );
  }
}
