
import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class BoxMemory extends StatelessWidget {
  final int percentValue;
  final double percent;
  final String memTotal;
  final String memAvailable;
  final String memUsed;
  final List<double> mem;
  final String cached;
  final String swapTotal;
  final String swapFree;

  const BoxMemory({
    super.key,
    required this.percent,
    required this.memTotal,
    required this.memAvailable,
    required this.memUsed,
    required this.mem,
    required this.cached,
    required this.swapTotal,
    required this.swapFree,
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
                      '$memTotal GB Total',
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
                  dataCount: mem.length,
                  yValueMapper: (index) => mem[index],
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
                      '$memUsed GB Usado',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '^$swapTotal Swap',
                      style: TextStyle(
                        color: AppColor.orangerColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '~$swapFree Swap',
                      style: TextStyle(
                        color: AppColor.greenColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$cached Cache',
                      style: TextStyle(
                        color: AppColor.pupleColor,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$memAvailable GB Livre',
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
