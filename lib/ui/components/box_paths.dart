import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxPaths extends StatelessWidget {
  final String element;
  final Color? color;
  const BoxPaths({super.key, required this.element, this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(left: 8, right: 8),
      curve: Curves.linear,
      duration: Duration(milliseconds: 550),
      height: 30,
      decoration: BoxDecoration(
        color: color ?? AppColor.blackBlueLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          element,
          style: TextStyle(color: AppColor.whiteColor, fontSize: 12),
        ),
      ),
    );
  }
}
