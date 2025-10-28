import 'dart:developer';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/device.dart';
import 'package:archify/core/models/memory.dart';
import 'package:archify/core/models/network.dart';
import 'package:archify/core/models/storage.dart';
import 'package:archify/core/services/info_device.dart';
import 'package:archify/ui/components/box_battery.dart';
import 'package:archify/ui/components/box_info_android.dart';
import 'package:archify/ui/components/box_memory.dart';
import 'package:archify/ui/components/box_model_proc.dart';
import 'package:archify/ui/components/box_process_frequence.dart';
import 'package:archify/ui/components/box_storage.dart';
import 'package:archify/ui/components/box_wifi_info.dart';
import 'package:flutter/material.dart';

class StatisticForNerds extends StatelessWidget {
  StatisticForNerds({super.key});

  final InfoDevice _infoDevice = InfoDevice();

  final List<double> _memoryList = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Android Statistics'),
        titleTextStyle: TextStyle(color: AppColor.whiteColor, fontSize: 18),
        backgroundColor: Color(0xff202124),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      backgroundColor: Color(0xff202124),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // stream Battery
                  StreamBuilder(
                    stream: _infoDevice.batteryInfoStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();

                      Map<String, dynamic>? data = snapshot.data;

                      if (data == null) return Container();
                      return BoxBattery(dataStream: data);
                    },
                  ),

                  // device info
                  FutureBuilder(
                    future: _infoDevice.getDeviceInfo(),
                    builder: (context, snapshot) {
                      Map<String, dynamic>? data = snapshot.data;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.greenColor,
                          ),
                        );
                      }

                      if (data == null) return Container();

                      final Device device = Device(dataDevice: data);

                      return BoxInfoAndroid(
                        onTap: () {
                          log(device.socModel.toString());
                        },
                        androidVersion: device.androidVersion,
                        manufacturer: device.manufacturer,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Stream Memory
              StreamBuilder(
                stream: _infoDevice.getStreamMemory,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  final Memory memory = Memory(dataMemory: data);

                  if (_memoryList.length > 30) _memoryList.removeAt(0);
                  _memoryList.add(double.parse(memory.used));

                  return BoxMemory(
                    percentValue: memory.percent.round(),
                    percent: memory.setPercent,
                    memoryTotal: memory.total,
                    memoryAvailable: memory.available,
                    memoryUsed: memory.used,
                    memoryPlotList: _memoryList,
                    memoryCached: memory.cached,
                    memorySwapTotal: memory.swapTotal,
                    memorySwapFree: memory.swapFree,
                  );
                },
              ),

              SizedBox(height: 10),

              FutureBuilder(
                future: _infoDevice.getDeviceInfo(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  final Device device = Device(dataDevice: data);

                  return Center(
                    child: BoxModelProc(socModel: device.readableSoc),
                  );
                },
              ),

              SizedBox(height: 10),

              StreamBuilder(
                stream: _infoDevice.frequenceCpuStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  List<double>? data = snapshot.data;

                  if (data == null) return Container();

                  return SizedBox(
                    width: size.width,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 10,
                      children: data
                          .asMap()
                          .entries
                          .map(
                            (element) => BoxProcessFrequence(
                              index: element.key + 1,
                              frequence: element.value,
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),

              SizedBox(height: 10),

              StreamBuilder(
                stream: _infoDevice.widfiInfoStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  final Network network = Network(dataNetwork: data);

                  return network.isWifiActive
                      ? BoxWifiInfo(
                          ssid: network.ssid,
                          bssid: network.bssid,
                          frequencyMHz: network.frequencyMHz,
                          ipAddress: network.ipAddress,
                          dbm: network.dbm,
                          speed: network.speed,
                          is5G: network.is5G,
                        )
                      : Container();
                },
              ),

              SizedBox(height: 10),

              StreamBuilder(
                stream: _infoDevice.getStreamStorage,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  final Storage storage = Storage(dataStorage: data);

                  return BoxStorage(
                    percent: storage.percent,
                    totalGB: storage.totalGB,
                    used: storage.usedGB,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
