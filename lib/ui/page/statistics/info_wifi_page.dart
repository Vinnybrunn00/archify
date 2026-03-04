import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/network.dart';
import 'package:archify/ui/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';

class InfoWifiPage extends StatelessWidget {
  final Stream<Map<String, dynamic>>? streamWifiInfo;

  const InfoWifiPage({super.key, required this.streamWifiInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        title: Text('Info Wifi'),
        titleTextStyle: TextStyle(fontSize: 18),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: StreamBuilder(
        stream: streamWifiInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.greenColor),
            );
          }

          if (!snapshot.hasData) return Container();
          final Map<String, dynamic>? data = snapshot.data;

          if (data == null) return Container();

          final Network network = Network(dataNetwork: data);
          return SingleChildScrollView(
            child: Column(
              children: network.toList().map((elements) {
                return ListTileCustom(
                  title: elements['key'],
                  trailing: elements['value'].toString(),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
