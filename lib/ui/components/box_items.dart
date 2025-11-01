import 'dart:io';

import 'package:archify/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:archify/constants/constants_color.dart';

class BoxItems extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final String name;
  final Widget? icon;
  final DateTime fileChanged;
  final int sizeFile;

  final bool isSelected;

  BoxItems({
    super.key,
    this.onTap,
    required this.name,
    required this.icon,
    required this.fileChanged,
    required this.sizeFile,
    this.onLongPress,
    required this.isSelected,
  });

  final Utils _utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 8, right: 8, left: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 550),
        curve: Curves.easeInSine,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: .5,
          animationDuration: Duration(milliseconds: 550),
          color: isSelected ? Color(0xff4150F7).withAlpha(50) : Colors.white,
          child: GestureDetector(
            child: InkWell(
              onLongPress: onLongPress,
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withAlpha(150),
                    width: .3,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Color(0xff4150F7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 15),
                      height: 35,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff4150F7).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: icon,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontSize: 17),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                _utils.setFormatHour(fileChanged),
                                style: TextStyle(
                                  color: AppColor.blackColorAlpha100,
                                  fontSize: 12.5,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                color: AppColor.blackColorAlpha70,
                                height: 15,
                                width: 1.5,
                              ),
                              SizedBox(width: 10),
                              Text(
                                _utils.formatBytes(sizeFile),
                                style: TextStyle(
                                  color: AppColor.blackColorAlpha100,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
