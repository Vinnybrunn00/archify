

import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/device.dart';
import 'package:archify/core/models/memory.dart';
import 'package:archify/core/models/network.dart';
import 'package:archify/core/models/storage.dart';
import 'package:archify/core/services/monitor_manager/battery_service.dart';
import 'package:archify/core/services/monitor_manager/cpu_services.dart';
import 'package:archify/core/services/monitor_manager/info_device.dart';
import 'package:archify/core/services/monitor_manager/memory_service.dart';
import 'package:archify/core/services/monitor_manager/sims_service.dart';
import 'package:archify/core/services/monitor_manager/storage_service.dart';
import 'package:archify/core/services/monitor_manager/wifi_service.dart';
import 'package:archify/ui/components/statistics/box_battery.dart';
import 'package:archify/ui/components/statistics/box_info_android.dart';
import 'package:archify/ui/components/statistics/box_sims.dart';
import 'package:archify/ui/components/statistics/box_memory.dart';
import 'package:archify/ui/components/statistics/box_model_proc.dart';
import 'package:archify/ui/components/statistics/box_process_frequence.dart';
import 'package:archify/ui/components/statistics/box_storage.dart';
import 'package:archify/ui/components/statistics/box_wifi_info.dart';
import 'package:archify/ui/page/statistics/info_android_page.dart';
import 'package:archify/ui/page/statistics/info_sims_page.dart';
import 'package:archify/ui/page/statistics/info_wifi_page.dart';
import 'package:archify/utils/utils.dart';
import 'package:flutter/material.dart';

class StatisticAndroid extends StatelessWidget {
  StatisticAndroid({super.key});

  final InfoDevice _infoDevice = InfoDevice();
  final StorageService _storageService = StorageService();
  final MemoryService _memoryService = MemoryService();
  final BatteryService _batteryService = BatteryService();
  final WifiService _wifiService = WifiService();
  final CPUServices _cpuServices = CPUServices();
  final SimsService _simsService = SimsService();

  final List<double> _memoryList = [];

  final Utils _utils = Utils();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Android Statistics'),
        titleTextStyle: TextStyle(color: AppColor.whiteColor, fontSize: 18),
        backgroundColor: AppColor.backgroundColorBlack,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      backgroundColor: AppColor.backgroundColorBlack,
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
                    stream: _batteryService.batteryInfoStream,
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
                          _utils.goToRoutePage(
                            context,
                            builder: (_) => InfoAndroidPage(
                              listInfoDevice: device.toList(),
                            ),
                          );
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
                stream: _memoryService.getStreamMemory,
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
                stream: _cpuServices.frequenceCpuStream,
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

              StreamBuilder<Map<String, dynamic>>(
                stream: _wifiService.wifiInfoStream,
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
                          onTap: () => _utils.goToRoutePage(
                            context,
                            builder: (_) => InfoWifiPage(
                              streamWifiInfo: _wifiService.wifiInfoStream,
                            ),
                          ),
                        )
                      : Container();
                },
              ),

              SizedBox(height: 10),

              StreamBuilder(
                stream: _storageService.getStreamStorage,
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

              FutureBuilder(
                future: _simsService.getSimInfo(),
                builder: (context, snapshot) {
                  final Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  final List<Object?> listSims = data['sims'];

                  return BoxInfoSims(
                    count: listSims.length,
                    onTap: () => _utils.goToRoutePage(
                      context,
                      builder: (_) => InfoSimsPage(listSims: listSims),
                    ),
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
