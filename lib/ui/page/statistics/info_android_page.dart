import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';

class InfoAndroidPage extends StatelessWidget {
  final List<Map<String, dynamic>> listInfoDevice;

  const InfoAndroidPage({super.key, required this.listInfoDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        title: Text('Info Android'),
        titleTextStyle: TextStyle(fontSize: 18),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: listInfoDevice
                .map(
                  (elements) => ListTileCustom(
                    title: elements['key'],
                    trailing: elements['value'].toString(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
