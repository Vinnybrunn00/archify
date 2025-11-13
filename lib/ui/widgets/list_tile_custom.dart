import 'package:archify/constants/constants_color.dart';
import 'package:archify/utils/utils.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ListTileCustom extends StatelessWidget {
  final String title;
  final String trailing;

  const ListTileCustom({
    super.key,
    required this.title,
    required this.trailing,
  });

  bool get setSSId => trailing.toLowerCase().contains('unknown');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListTile(
      onTap: () async {
        final Utils utils = Utils();
        await FlutterClipboard.copyWithCallback(
          text: trailing,
          onSuccess: () {
            utils.showMessageError(context, message: 'Copied to Clipboard');
          },
        );
      },
      shape: Border.symmetric(
        horizontal: BorderSide(
          color: AppColor.backgroundColorWhite.withAlpha(90),
          width: .13,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColor.whiteColor, fontSize: 14.5),
      ),

      trailing: InkWell(
        onTap: setSSId
            ? () async {
                await Permission.location.request();
                await Geolocator.openLocationSettings();
              }
            : null,
        child: SizedBox(
          width: size.width * .3,
          child: Text(
            setSSId ? 'Click to grant permission' : trailing,
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ),
    );
  }
}
