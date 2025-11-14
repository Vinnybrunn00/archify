
import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/sims.dart';
import 'package:archify/ui/widgets/box_info_sims.dart';
import 'package:flutter/material.dart';

class InfoSimsPage extends StatelessWidget {
  final List<Object?> listSims;

  const InfoSimsPage({super.key, required this.listSims});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text('Sims Info', style: TextStyle(color: AppColor.whiteColor)),
      ),
      body: ListView.builder(
        itemCount: listSims.length,
        itemBuilder: (context, index) {
          final mapSims = listSims[index] as Map<Object?, Object?>;

          final Sims sims = Sims(listSims: mapSims);

          return BoxInfoSims(listSims: sims.toList());
        },
      ),
    );
  }
}
