import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/widgets/event_button.dart';
import 'package:flutter/material.dart';

class BoxInfoSims extends StatelessWidget {
  final void Function()? onTap;

  const BoxInfoSims({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 650),
      margin: EdgeInsets.only(left: 8),
      padding: EdgeInsets.only(left: 8, right: 8),
      height: size.height * .082,
      width: size.width * .42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.greenColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.sim_card, color: AppColor.whiteColor, size: 35),
              SizedBox(width: 8),
              Text(
                'Info Sims',
                style: TextStyle(color: AppColor.whiteColor, fontSize: 14),
              ),
            ],
          ),
          EventButton(onTap: onTap),
        ],
      ),
    );
  }
}
