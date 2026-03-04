import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/sims.dart';
import 'package:archify/core/services/monitor_manager/sims_service.dart';
import 'package:archify/ui/widgets/box_info_sims.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class InfoSimsPage extends StatefulWidget {
  const InfoSimsPage({super.key});

  @override
  State<InfoSimsPage> createState() => _InfoSimsPageState();
}

class _InfoSimsPageState extends State<InfoSimsPage> {
  final SimsService _simsService = SimsService();

  late Future<Map<String, dynamic>> _getSimInfo;

  @override
  void initState() {
    super.initState();
    _getSimInfo = _simsService.getSimInfo();
  }

  void _reload() async {
    final PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      setState(() {
        _getSimInfo = _simsService.getSimInfo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text('Sims Info', style: TextStyle(color: AppColor.whiteColor)),
      ),
      body: FutureBuilder(
        future: _getSimInfo,
        builder: (context, snapshot) {
          final Map<String, dynamic>? data = snapshot.data;

          if (data == null) return Container();

          final List<Object?> listSims = data['sims'];

          return listSims.isEmpty
              ? Center(
                  child: InkWell(
                    onTap: () => _reload(),
                    child: Text(
                      'click to autorize',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: listSims.length,
                  itemBuilder: (context, index) {
                    final mapSims = listSims[index] as Map<Object?, Object?>;

                    final Sims sims = Sims(mapSims: mapSims);

                    return BoxInfoSims(listSims: sims.toList());
                  },
                );
        },
      ),
    );
  }
}
