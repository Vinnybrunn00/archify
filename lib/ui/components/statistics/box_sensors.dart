import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/widgets/event_button.dart';
import 'package:flutter/material.dart';

class BoxSensors extends StatelessWidget {
  final int count;
  final void Function()? onTap;

  const BoxSensors({super.key, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 550),
        margin: EdgeInsets.only(left: 8, right: 8),
        padding: EdgeInsets.only(left: 8, right: 8),
        height: size.height * .082,
        width: size.width * .42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.greenColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.sensors, color: AppColor.whiteColor, size: 35),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Sensors',
                          style: TextStyle(color: AppColor.whiteColor),
                        ),
                      ],
                    ),
                  ],
                ),
                EventButton(onTap: onTap),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
