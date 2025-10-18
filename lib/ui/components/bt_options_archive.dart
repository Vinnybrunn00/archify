import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BtOptionsArchive extends StatelessWidget {
  final String title;
  final IconData iconData;
  final double? iconSize;
  final bool? isDirectory;
  final void Function()? onTap;

  final void Function(TapDownDetails)? onTapDown;

  const BtOptionsArchive({
    super.key,
    required this.iconData,
    this.iconSize,
    required this.title,
    this.onTap,
    this.isDirectory = false, this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTapDown: onTapDown,
        onTap: isDirectory! ? null : onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: EdgeInsets.only(left: 8, right: 8),
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: iconSize ?? 19,
                color: isDirectory!
                    ? AppColor.greyColor.withAlpha(180)
                    : AppColor.whiteColor,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: isDirectory!
                      ? AppColor.greyColor.withAlpha(180)
                      : AppColor.whiteColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
