import 'package:archify/constants/constants_color.dart';
import 'package:flutter/material.dart';

class BoxStorageMsgRoot extends StatelessWidget {
  const BoxStorageMsgRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColor.pupleColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Root Storage (/)',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
  }
}