import 'dart:io';

import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/services/files_services.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String path;
  final String nameFile;

  const ImageView({super.key, required this.path, required this.nameFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorBlack,
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(
          nameFile,
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 17,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: InteractiveViewer(
                maxScale: 5,
                child: Image.file(
                  File(path),
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: GestureDetector(
                onTap: () async {
                  final FilesServices filesServices = FilesServices();
                  await filesServices.onShareOnlyFile(path, nameFile);
                },
                child: Icon(Icons.share, color: AppColor.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
