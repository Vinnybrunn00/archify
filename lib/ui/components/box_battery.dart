

import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/components/info_battery.dart';
import 'package:archify/ui/components/stack_battery.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BoxBattery extends StatelessWidget {
  final Map<String, dynamic> dataStream;

  const BoxBattery({super.key, required this.dataStream});

  List<InfoBattery> get _listBatteryInfo => [
    InfoBattery(
      info: "${dataStream['plugged_type']}",
      iconData: MingCute.usb_fill,
      color: Colors.cyanAccent,
    ),
    InfoBattery(
      info: "Saúde: ${dataStream['health']}",
      iconData: OctIcons.heart,
      color: Colors.redAccent,
    ),
    InfoBattery(
      info: "Tecnologia: ${dataStream['technology']}",
      iconData: IonIcons.finger_print,
      color: AppColor.greyColor,
    ),
    InfoBattery(
      info: "Temp: ${dataStream['temperature_celsius']} ºC",
      iconData: FontAwesome.temperature_half_solid,
      color: AppColor.orangerColor,
    ),
    InfoBattery(
      info: "Volts: ${dataStream['voltage_mv']} mV",
      iconData: Icons.flash_on,
      color: Colors.yellow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      width: size.width * .55,
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 8),
      duration: Duration(microseconds: 550),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bateria',
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StackBattery(
                percent: dataStream['level'],
                charging: dataStream['status'],
              ),
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
