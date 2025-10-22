import 'dart:developer';

import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/components/box_battery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatisticForNerds extends StatelessWidget {
  StatisticForNerds({super.key});

  final EventChannel _platform = EventChannel('archify/battery_info');

  Stream<Map<String, dynamic>> get batteryInfoStream {
    return _platform.receiveBroadcastStream().map((dynamic event) {
      return (event as Map).cast<String, dynamic>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202124),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: batteryInfoStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('error');

                Map<String, dynamic> data = snapshot.data!;
                return BoxBattery(dataStream: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
