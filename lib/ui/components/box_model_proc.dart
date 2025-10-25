import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxModelProc extends StatelessWidget {
  final String socModel;
  const BoxModelProc({super.key, required this.socModel});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: AnimatedContainer(
        height: 30,
        width: size.width * .6,
        margin: EdgeInsets.only(left: 8, right: 8),
        duration: Duration(milliseconds: 550),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.greenColor),
        ),
        child: Center(
          child: Text(
            socModel,
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ),
    );
  
  }
}