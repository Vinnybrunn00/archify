import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Color? color;
  final Color? styleTextColor;

  const InputText({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.color,
    this.styleTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      onChanged: onChanged,
      cursorHeight: 20,
      cursorWidth: 1,
      style: TextStyle(color: styleTextColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: color ?? AppColor.blackColorAlpha55,
          fontSize: 12.5,
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color ?? AppColor.blackColorAlpha55),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.pupleColor),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
