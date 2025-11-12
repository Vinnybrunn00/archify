import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BoxInfoAndroid extends StatelessWidget {
  final String androidVersion;
  final String manufacturer;
  final void Function()? onTap;

  const BoxInfoAndroid({
    super.key,
    required this.androidVersion,
    required this.manufacturer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 550),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: size.height * .16,
          width: size.width * .38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.greenColor),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IonIcons.logo_android, color: AppColor.greenColor, size: 35),
              Text(
                'Android $androidVersion',
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                manufacturer,
                style: TextStyle(color: AppColor.whiteColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
