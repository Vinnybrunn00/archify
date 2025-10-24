import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/services/info_device.dart';
import 'package:archify/ui/components/box_battery.dart';
import 'package:flutter/material.dart';

class StatisticForNerds extends StatelessWidget {
  StatisticForNerds({super.key});

  final InfoDevice _infoDevice = InfoDevice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202124),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: _infoDevice.batteryInfoStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('error');

                Map<String, dynamic> data = snapshot.data!;
                return BoxBattery(dataStream: data);
              },
            ),

            FutureBuilder(
              future: _infoDevice.getCpuInfo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('error');
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(color: AppColor.whiteColor),
                );
              },
            ),

            SizedBox(height: 20),
            FutureBuilder(
              future: _infoDevice.getDeviceInfo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('error');
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(color: AppColor.whiteColor),
                );
              },
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: _infoDevice.getStreamMemory,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('data');

                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(color: AppColor.whiteColor),
                );
              },
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: _infoDevice.getStreamStorage,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('error');
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(color: AppColor.whiteColor),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
