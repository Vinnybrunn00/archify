import 'dart:developer';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/services/info_device.dart';
import 'package:archify/ui/components/box_battery.dart';
import 'package:archify/ui/components/box_info_android.dart';
import 'package:archify/ui/components/box_memory.dart';
import 'package:archify/ui/components/box_model_proc.dart';
import 'package:archify/ui/components/box_process_frequence.dart';
import 'package:archify/utils/utils.dart';
import 'package:flutter/material.dart';

class StatisticForNerds extends StatelessWidget {
  StatisticForNerds({super.key});

  final InfoDevice _infoDevice = InfoDevice();
  final Utils _utils = Utils();

  final List<double> _mem = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas do Android'),
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
                    future: _infoDevice.getDeviceInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('error');

                      Map<String, dynamic>? data = snapshot.data;
                      if (data == null) return Container();

                      return BoxInfoAndroid(
                        onTap: () {
                          log(data.toString());
                        },
                        androidVersion: data['android_version'],
                        manufacturer: data['manufacturer'],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder(
                stream: _infoDevice.getStreamMemory,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('data');

                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Text('data');

                  final String memTotal = data['MemTotal'];
                  final String memAvailable = data['MemAvailable'];
                  final String cached = data['Cached'];
                  final String swapTotal = data['SwapTotal'];
                  final String swapFree = data['SwapFree'];

                  final String memUsed =
                      (double.parse(memTotal) - double.parse(memAvailable))
                          .toStringAsFixed(2);

                  final percent = _utils.convertBatteryPercent(
                    memTotal: memTotal,
                    memAvailable: memAvailable,
                  );

                  final double parse = double.parse(
                    '0.${percent.toString().substring(0, 2)}',
                  );

                  if (_mem.length > 30) _mem.removeAt(0);
                  _mem.add(double.parse(memUsed));

                  return BoxMemory(
                    percentValue: percent.round(),
                    percent: percent.round() == 100 ? 1 : parse,
                    memTotal: memTotal,
                    memAvailable: memAvailable,
                    memUsed: memUsed,
                    mem: _mem,
                    cached: cached,
                    swapTotal: swapTotal,
                    swapFree: swapFree,
                  );
                },
              ),

              SizedBox(height: 10),

              FutureBuilder(
                future: _infoDevice.getDeviceInfo(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('error');

                  Map<String, dynamic>? data = snapshot.data;

                  if (data == null) return Container();

                  return Center(
                    child: BoxModelProc(
                      socModel: _utils.getSocReadableName(data['soc_model']),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),

              StreamBuilder(
                stream: _infoDevice.frequenceCpuStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('error');

                  if (snapshot.data == null) return Container();

                  return SizedBox(
                    width: size.width,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 10,
                      children: snapshot.data!
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
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(color: AppColor.whiteColor),
                  );
                },
              ),
              SizedBox(height: 10),
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
      ),
    );
  }
}
