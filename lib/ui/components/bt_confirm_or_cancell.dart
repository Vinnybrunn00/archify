import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BtConfirmOrCancell extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onTap;

  const BtConfirmOrCancell({
    super.key,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: AppColor.blackColorAlpha70,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 50,
          width: size.width * .38,
          child: Center(
            child: Text(text, style: TextStyle(color: color, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
