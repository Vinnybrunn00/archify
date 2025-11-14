import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxInfoSims extends StatelessWidget {
  final int count;
  final void Function()? onTap;

  const BoxInfoSims({super.key, this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 650),
      margin: EdgeInsets.only(left: 8, top: 10),
      height: size.height * .08,
      width: size.width * .42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.sim_card, color: AppColor.whiteColor, size: 35),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: TextStyle(color: AppColor.whiteColor, fontSize: 14),
              ),
              Text(
                'Info Sims',
                style: TextStyle(color: AppColor.whiteColor, fontSize: 14),
              ),
            ],
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30 / 2),
            child: Ink(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30 / 2),
              ),
              child: Icon(
                Icons.keyboard_arrow_right_outlined,
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
