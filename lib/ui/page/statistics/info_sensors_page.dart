import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/style/app_style.dart';
import 'package:flutter/material.dart';

class InfoSensorsPage extends StatelessWidget {
  final List<Map<String, dynamic>> dataSensors;

  const InfoSensorsPage({super.key, required this.dataSensors});

  String capitalizer(String string) {
    String result = '';
    for (String latter in string.split('_')) {
      String firstAllLatter = latter[0].toUpperCase();
      String restLatter = latter.substring(1, latter.length);
      result = '$result ${firstAllLatter + restLatter}';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text('Sensors', style: TextStyle(color: AppColor.whiteColor)),
      ),
      body: ListView.builder(
        itemCount: dataSensors.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> sensor = dataSensors[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 550),
            margin: EdgeInsets.only(left: 8, right: 8, top: 8),
            padding: EdgeInsets.all(8),
            width: size.width,
            decoration: BoxDecoration(
              color: AppColor.blackBlueLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1} - ${sensor['name'].toUpperCase()}',
                  style: TextStyle(
                    color: AppColor.backgroundColorWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  children: sensor.entries
                      .map<Row>(
                        (maps) => Row(
                          children: [
                            Text(
                              '${capitalizer(maps.key)}: ',
                              style: AppStyle.s13ftAlpha180Weight600,
                            ),
                            Text(
                              maps.value.toString(),
                              style: AppStyle.s13ftAlpha180,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
