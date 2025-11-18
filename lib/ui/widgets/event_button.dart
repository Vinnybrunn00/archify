import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final void Function()? onTap;

  const EventButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30 / 2),
      child: Ink(
        height: 30,
        width: 30,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30 / 2)),
        child: Icon(
          Icons.keyboard_arrow_right_outlined,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}
