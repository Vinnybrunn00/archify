import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class InfoAndroidPage extends StatelessWidget {
  final List<Map<String, dynamic>> listInfoDevice;

  const InfoAndroidPage({super.key, required this.listInfoDevice});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        title: Text('Info Android'),
        titleTextStyle: TextStyle(fontSize: 18),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
      ),
      body: SafeArea(
        child: Column(
          children: listInfoDevice
              .map(
                (elements) => ListTile(
                  title: Text(
                    elements['key'],
                    style: TextStyle(color: AppColor.whiteColor, fontSize: 15),
                  ),

                  trailing: SizedBox(
                    width: size.width * .3,
                    child: Text(
                      elements['value'].toString(),
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
