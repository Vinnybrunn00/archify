import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';

class BoxItems extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onDelete;
  final String name;
  final Widget? icon;

  const BoxItems({
    super.key,
    this.onTap,
    this.onDelete,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: .5,
      animationDuration: Duration(milliseconds: 550),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.only(right: 8),
          height: 65,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(150), width: .3),
          ),
          child: Row(
            children: [
              Container(
                height: 65,
                width: 8,
                decoration: BoxDecoration(
                  color: Color(0xff4150F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 15),
                height: 35,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xff4150F7).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: icon,
              ),
              Expanded(child: Text(name)),
              InkWell(
                onTap: onDelete,
                child: Icon(
                  FontAwesome.trash_can,
                  size: 19,
                  color: AppColor.blackColorAlpha100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
