import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';

class BoxInfoSims extends StatelessWidget {
  final List<Map<String, dynamic>> listSims;

  const BoxInfoSims({super.key, required this.listSims});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 550),
      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
      width: size.width,
      decoration: BoxDecoration(
        color: AppColor.greyColor.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: listSims.toList().map((elements) {
            return ListTileCustom(
              title: elements['key'],
              trailing: elements['value'].toString(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
