import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class BoxMemory extends StatelessWidget {
  final int percentValue;
  final double percent;
  final String memoryTotal;
  final String memoryAvailable;
  final String memoryUsed;
  final List<double> memoryPlotList;
  final String memoryCached;
  final String memorySwapTotal;
  final String memorySwapFree;

  const BoxMemory({
    super.key,
    required this.percent,
    required this.memoryTotal,
    required this.memoryAvailable,
    required this.memoryUsed,
    required this.memoryPlotList,
    required this.memoryCached,
    required this.memorySwapTotal,
    required this.memorySwapFree,
    required this.percentValue,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 550),
      height: size.height * .16,
      width: size.width,
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularPercentIndicator(
                arcType: ArcType.FULL,
                startAngle: 180,
                arcBackgroundColor: const Color(0x544150F7),
                radius: 40,
                lineWidth: 4,
                percent: percent,
                footer: Column(
                  children: [
                    Text(
                      'RAM',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$memoryTotal GB Total',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                center: Text(
                  '$percentValue%',
                  style: TextStyle(color: AppColor.pupleColor, fontSize: 13),
                ),
                progressColor: AppColor.pupleColor,
              ),

              SizedBox(
                width: size.width * .43,
                child: SfSparkLineChart.custom(
                  dataCount: memoryPlotList.length,
                  yValueMapper: (index) => memoryPlotList[index],
                  xValueMapper: (index) => index,
                  axisLineWidth: 2,
                  firstPointColor: Colors.blue,
                  lastPointColor: AppColor.redColor,
                  highPointColor: AppColor.greenColor,
                  lowPointColor: AppColor.orangerColor,
                  axisLineDashArray: const [2, 2],
                  color: AppColor.greenColor,
                ),
              ),

              SizedBox(
                height: size.height * .125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$memoryUsed GB Used',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '^$memorySwapTotal Swap',
                      style: TextStyle(
                        color: AppColor.orangerColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '~$memorySwapFree Swap',
                      style: TextStyle(
                        color: AppColor.greenColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$memoryCached Cache',
                      style: TextStyle(
                        color: AppColor.pupleColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$memoryAvailable GB Free',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
