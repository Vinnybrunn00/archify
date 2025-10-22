import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/components/info_battery.dart';
import 'package:archify/ui/components/stack_battery.dart';
import 'package:flutter/material.dart';

class BoxBattery extends StatelessWidget {
  final Map<String, dynamic> dataStream;

  const BoxBattery({super.key, required this.dataStream});

  List<InfoBattery> get _listBatteryInfo => [
    InfoBattery(info: "Porcentagem: ${dataStream['level']}%"),
    InfoBattery(info: "Status: ${dataStream['status']}"),
    InfoBattery(info: "${dataStream['plugged_type']}"),
    InfoBattery(info: "${dataStream['health']}"),
    InfoBattery(info: "${dataStream['technology']}"),
    InfoBattery(info: "${dataStream['temperature_celsius']} ºC"),
    InfoBattery(info: "${dataStream['voltage_mv']}"),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      height: size.height * .3,
      width: size.width * .7,
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.all(12),
      duration: Duration(microseconds: 550),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StackBattery(percent: dataStream['level']),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _listBatteryInfo.map((elements) => elements).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
