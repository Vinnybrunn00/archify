import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class MiniBtIcon extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;

  const MiniBtIcon({super.key, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40 / 2),
      child: Ink(
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40 / 2)),
        child: Icon(
          icon,
          size: 23,
          color: AppColor.blackBlue,
        ),
      ),
    );
  }
}
