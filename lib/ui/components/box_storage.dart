import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BoxStorage extends StatelessWidget {
  final int percent;
  final double totalGB;
  final double used;

  const BoxStorage({
    super.key,
    required this.percent,
    required this.totalGB,
    required this.used,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      margin: EdgeInsets.only(left: 8, right: 8),
      width: size.width,
      duration: Duration(milliseconds: 550),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Row(
        children: [
          Icon(FontAwesome.sd_card_solid, color: AppColor.whiteColor, size: 30),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Memoria Interna',
                style: TextStyle(color: AppColor.whiteColor, fontSize: 15),
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    color: Colors.white.withAlpha(50),
                    height: 3,
                    width: size.width * .71,
                  ),
                  Container(
                    color: AppColor.whiteColor,
                    height: 3,
                    width:
                        (size.width * .71) *
                        (double.parse('.$percent')).clamp(0.0, 1.0),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Total: ${totalGB.toStringAsFixed(1)} GB',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 10.5,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Usada: ${used.toStringAsFixed(1)} GB',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 8),
          Text(
            '$percent%',
            style: TextStyle(
              color: AppColor.backgroundColorWhite,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
