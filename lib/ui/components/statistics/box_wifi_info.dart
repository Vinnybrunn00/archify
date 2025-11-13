import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BoxWifiInfo extends StatelessWidget {
  final String dbm;
  final String ssid;
  final String bssid;
  final String frequencyMHz;
  final String ipAddress;
  final String speed;
  final bool is5G;
  final void Function()? onTap;

  const BoxWifiInfo({
    super.key,
    required this.dbm,
    required this.ssid,
    required this.speed,
    required this.is5G,
    required this.bssid,
    required this.frequencyMHz,
    required this.ipAddress,
    this.onTap,
  });

  bool get setSSId => ssid.contains('unknown');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      padding: EdgeInsets.only(left: 12, top: 15, bottom: 15, right: 8),
      margin: EdgeInsets.only(left: 8, right: 8, top: 2),
      width: size.width,
      duration: Duration(milliseconds: 650),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  setPotencialdBm(dbm),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: setSSId
                                ? () async {
                                    await Permission.location.request();
                                    await Geolocator.openLocationSettings();
                                  }
                                : null,
                            child: Text(
                              setSSId ? 'click to authorize' : ssid,
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          setSSId
                              ? Container()
                              : Container(
                                  height: 16,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColor.greenColor.withAlpha(130),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      is5G ? '5G' : '2.4G',
                                      style: TextStyle(
                                        color: AppColor.greenColor.withAlpha(
                                          130,
                                        ),
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Speed: ^$speed',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Power: $dbm',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(30 / 2),
                child: Ink(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30 / 2),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget setPotencialdBm(String dbm) {
    final newValue = int.tryParse(
      dbm.trim().replaceAll('dBm', '').replaceAll('-', ''),
    );

    if (newValue == null) {
      return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
    }

    if (newValue <= 30 || newValue <= 41) {
      return Icon(BoxIcons.bx_wifi, color: Colors.white, size: 35);
    } else if (newValue >= 40 || newValue <= 50) {
      return Icon(BoxIcons.bx_wifi, color: Colors.white, size: 35);
    } else if (newValue >= 51 || newValue <= 60) {
      return Icon(BoxIcons.bx_wifi_2, color: Colors.white, size: 35);
    } else if (newValue >= 61 || newValue <= 67) {
      return Icon(BoxIcons.bx_wifi_2, color: Colors.white, size: 35);
    } else if (newValue >= 68 || newValue <= 70) {
      return Icon(BoxIcons.bx_wifi_1, color: Colors.white, size: 35);
    } else if (newValue >= 71 || newValue <= 80) {
      return Icon(BoxIcons.bx_wifi_1, color: Colors.white, size: 35);
    } else if (newValue >= 80) {
      return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
    } else {
      return Icon(BoxIcons.bx_wifi_off, color: Colors.white, size: 35);
    }
  }
}
