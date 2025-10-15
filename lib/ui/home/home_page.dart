import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/constants/constants_regex.dart';
import 'package:archify/core/models/file_types.dart';
import 'package:archify/core/services/app_services.dart';
import 'package:archify/ui/components/box_create_items.dart';
import 'package:archify/ui/components/box_items.dart';
import 'package:archify/ui/view/app_pdf_view.dart';
import 'package:archify/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  final List<FileSystemEntity>? listItems;
  final String? name;
  final String? path;

  const HomePage({super.key, this.listItems, this.name, this.path});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final AppServices _appServices = AppServices();
  bool _isValid = false;

  List<FileSystemEntity> _list = [];

  void _loadListFolders() async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory != null) {
      final String path = directory.parent.path;
      List<FileSystemEntity> list = _appServices.listFolders(
        widget.path ?? path,
      );

      setState(() {
        _list = list;

        _controller.clear();
        _isValid = false;
      });
    }
  }

  void _update() {
    setState(() {
      _list = widget.listItems!;

      _controller.clear();
      _isValid = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.listItems != null) {
      _update();
    } else {
      _loadListFolders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Text(
          widget.name ?? 'Home Page',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actionsPadding: EdgeInsets.only(right: 30),
        actions: [
          InkWell(
            onTap: () async {
              final Directory? directory = await getDownloadsDirectory();
              if (directory == null) return;

              String pathTo = widget.path ?? directory.parent.path;

              final result = await FilePicker.platform.pickFiles();

              if (result != null) {
                final file = result.files.single;

                if (file.path == null) return;

                _appServices.copyFiles(
                  name: file.name,
                  fromPath: file.path!,
                  toPath: pathTo,
                );

                _loadListFolders();

                if (widget.listItems != null) {
                  _update();
                }
              }
            },
            child: Icon(
              EvaIcons.cloud_upload_outline,
              size: 23,
              color: AppColor.blackBlue,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxCreateItems(
                controller: _controller,
                colorButtonCreateFolder: _isValid
                    ? AppColor.pupleColor
                    : AppColor.pupleLowColor,
                onChanged: (String newFolder) {
                  setState(() {
                    if (newFolder.isNotEmpty) {
                      _isValid = true;
                    } else {
                      _isValid = false;
                    }
                  });
                },
                onCreateFolder: _isValid
                    ? () {
                        _appServices.createFolder(
                          _controller.text,
                          widget.path,
                        );
                        _loadListFolders();

                        if (widget.listItems != null) {
                          _update();
                        }
                      }
                    : null,
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    String nameFolder = _list[index].path.split('/').last;
                    String path = _list[index].path;

                    final Directory directory = Directory(path);
                    final File file = File(path);

                    FileStat fileStat = file.statSync();
                    FileStat dicStats = directory.statSync();

                    final FileTypes fileTypes = FileTypes(
                      isImage: imageExtensions.hasMatch(path),
                      isPdf: pdfExtRegex.hasMatch(path),
                      isVideo: videoExtRegex.hasMatch(path),
                      isAudio: audioExtRegex.hasMatch(path),
                      isText: textExtRegex.hasMatch(path),
                      isCode: codeExtRegex.hasMatch(path),
                    );

                    return Padding(
                      padding: EdgeInsetsGeometry.only(
                        top: 8,
                        right: 8,
                        left: 8,
                      ),
                      child: BoxItems(
                        icon: Utils.leading(dicStats.type, file, fileTypes),
                        onTap: () {
                          bool isDirectory =
                              dicStats.type == FileSystemEntityType.directory;

                          // open new folder
                          if (isDirectory) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HomePage(
                                  path: path,
                                  listItems: directory.listSync(),
                                  name: nameFolder,
                                ),
                              ),
                            );
                          }

                          if (fileTypes.isPdf) {
                            log(path);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PdfViewer(path: path),
                              ),
                            );
                          }
                        },
                        onDelete: () async {
                          await _appServices.delete(path);
                          _loadListFolders();
                        },
                        name: nameFolder,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
