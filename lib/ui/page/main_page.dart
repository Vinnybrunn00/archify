import 'dart:io';
import 'package:archify/constants/constants_value.dart';
import 'package:archify/core/models/files_directory_manager.dart';
import 'package:archify/core/services/file_service_manager/create_folder.dart';
import 'package:archify/core/services/file_service_manager/delete_file_folder.dart';
import 'package:archify/core/services/file_service_manager/rename_file_folder.dart';
import 'package:archify/core/services/file_service_manager/select_copy_file.dart';
import 'package:archify/core/services/files_services.dart';
import 'package:archify/ui/components/box_options_archive.dart';
import 'package:archify/ui/components/box_storage_msg_root.dart';
import 'package:archify/ui/components/mini_bt_icon.dart';
import 'package:archify/ui/page/statistic.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/ui/components/box_create_items.dart';
import 'package:archify/ui/components/box_items.dart';
import 'package:archify/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  final List<FileSystemEntity>? listItems;
  final String? name;
  final String? path;
  final List<String>? splitFiles;

  const MainPage({
    super.key,
    this.listItems,
    this.name,
    this.path,
    this.splitFiles,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FilesServices _filesServices = FilesServices();
  final Utils _utils = Utils();
  final TextEditingController _newNameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isValid = false;
  bool _isDirectory = false;
  bool _isLoading = false;

  String _path = '';
  String _nameFile = '';

  List<FileSystemEntity> _listFolders = [];

  int? _index;

  void _addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    });
  }

  void _loadListFolders() async {
    final Directory? directory = await getDownloadsDirectory();

    if (directory != null) {
      final String path = directory.parent.path;

      List<FileSystemEntity> listFolders = _filesServices.listFolders(
        widget.path ?? path,
      );

      setState(() {
        _listFolders = listFolders;

        _textController.clear();
        _isValid = false;
      });
    }
  }

  void _update() {
    setState(() {
      _listFolders = widget.listItems!;
      _textController.clear();
      _isValid = false;
    });
  }

  void _selectDisable() {
    setState(() => _index = null);
    FocusScope.of(context).unfocus();
  }

  void _onLongPress({
    required int index,
    required bool isSelected,
    required FilesDirectoryManager directoryManager,
  }) {
    setState(() {
      _isDirectory = directoryManager.isDirectory;
      _nameFile = directoryManager.nameFile;

      if (isSelected) {
        _index = null;
      } else {
        _index = index;
        _path = directoryManager.path;
      }
      _isLoading = !_isLoading;
    });

    if (!isSelected) {
      Future.delayed(Duration(milliseconds: 680), () {
        setState(() {
          _isLoading = !_isLoading;
        });
      });
    } else {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  AnimationController? _controllerAnimation;
  Animation<Offset>? _animation;


  

  @override
  void initState() {
    super.initState();


    

    if (widget.listItems != null) {
      _update();
    } else {
      _loadListFolders();
    }

    _addPostFrameCallback();

    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = Tween(begin: Offset(0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controllerAnimation!, curve: Curves.linear),
    );
    _controllerAnimation?.forward();
  }

  Future<void> _closePage() async {
    await _controllerAnimation?.reverse();
    if (mounted) {
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllerAnimation?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await _controllerAnimation?.reverse();
        await Future.delayed(Duration(milliseconds: 280));

        if (context.mounted) {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode.value
            ? AppColor.backgroundColorBlack
            : AppColor.whiteColor,
        appBar: AppBar(
          toolbarHeight: 50,
          elevation: 0,
          backgroundColor: isDarkMode.value
              ? AppColor.backgroundColorBlack
              : AppColor.whiteColor,
          leading: widget.name == null && _index == null
              ? null
              : IconButton(
                  onPressed: _index != null
                      ? () => _selectDisable()
                      : _closePage,
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode.value
                        ? AppColor.whiteColor
                        : AppColor.backgroundColorBlack,
                  ),
                ),
          title: Text(
            _index != null ? _path.split('/').last : (widget.name ?? 'Archify'),
            style: TextStyle(
              color: isDarkMode.value
                  ? AppColor.whiteColor
                  : AppColor.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: _index != null ? 18 : 20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actionsPadding: EdgeInsets.only(right: 20),
          actions: [
            if (widget.name == null && _index == null)
              MiniBtIcon(
                color: isDarkMode.value
                    ? AppColor.whiteColor
                    : AppColor.blackColor,
                onTap: () =>
                    setState(() => isDarkMode.value = !isDarkMode.value),
                icon: Icons.light_mode_outlined,
              ),
            SizedBox(width: 10),
            MiniBtIcon(
              color: isDarkMode.value
                  ? AppColor.whiteColor
                  : AppColor.blackColor,
              onTap: () async {
                final SelectCopyFile onSelectAndCopyFile = SelectCopyFile(
                  path: widget.path,
                );

                await onSelectAndCopyFile.onSelectAndCopy();

                if (onSelectAndCopyFile.errorMessage == null) {
                  _loadListFolders();

                  if (widget.listItems != null) {
                    _update();
                  }
                } else {
                  if (!context.mounted) return;

                  _utils.showMessageError(
                    context,
                    message: onSelectAndCopyFile.errorMessage!,
                  );
                }
              },
              icon: EvaIcons.cloud_upload_outline,
            ),
            SizedBox(width: 10),
            MiniBtIcon(
              color: isDarkMode.value
                  ? AppColor.whiteColor
                  : AppColor.blackColor,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => StatisticForNerds()));
              },
              icon: MingCute.bug_line,
            ),
          ],
        ),

        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        BoxStorageMsgRoot(),

                        if (widget.splitFiles != null) ...[
                          widget.splitFiles![1].split('/').isEmpty
                              ? Container()
                              : Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: isDarkMode.value
                                      ? AppColor.whiteColor
                                      : AppColor.blackColor,
                                ),

                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _utils.sliderAnimationPath(
                                    widget.splitFiles,
                                    _animation,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    BoxCreateFolders(
                      controller: _textController,
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
                          ? () async {
                              FocusScope.of(context).unfocus();

                              final CreateFolderManager folder =
                                  CreateFolderManager(
                                    newFolder: _textController.text,
                                    path: widget.path,
                                  );

                              await folder.create();

                              if (folder.errorMessage != null &&
                                  context.mounted) {
                                _utils.showMessageError(
                                  context,
                                  message: folder.errorMessage!,
                                );
                              }

                              _loadListFolders();

                              if (widget.listItems != null) {
                                _update();
                              }
                            }
                          : null,
                    ),
                    Expanded(
                      child: _listFolders.isNotEmpty
                          ? ListView.builder(
                              itemCount: _listFolders.length,
                              itemBuilder: (context, index) {
                                final FilesDirectoryManager directoryManager =
                                    FilesDirectoryManager(
                                      fileEntity: _listFolders[index],
                                    );

                                final bool isSelected = _index == index;

                                return BoxItems(
                                  icon: directoryManager.leading(),
                                  name: directoryManager.nameFile,
                                  fileChanged: directoryManager.modified,
                                  sizeFile: directoryManager.size,
                                  isSelected: isSelected,
                                  onLongPress: () => _onLongPress(
                                    index: index,
                                    isSelected: isSelected,
                                    directoryManager: directoryManager,
                                  ),
                                  onTap: _index == null
                                      ? () => directoryManager
                                            .openFilesAndFolder(context)
                                      : null,
                                );
                              },
                            )
                          : Text('Empty directory'),
                    ),
                  ],
                ),

                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColor.greenColor,
                        ),
                      )
                    : Container(),

                BoxOptionsArchive(
                  isDirectory: _isDirectory,
                  transform: Matrix4.translationValues(
                    0,
                    _index != null ? 0 : size.height,
                    0,
                  ),
                  onMove: () {},
                  onShare: () async {
                    await _filesServices.onShareOnlyFile(
                      widget.path ?? _path,
                      _nameFile,
                    );
                  },

                  onDelete: () async => await _utils.showModal(
                    context,
                    size: size,
                    onDelete: () async {
                      final DeleteFileFolder deleteFileFolder =
                          DeleteFileFolder(path: widget.path ?? _path);

                      await deleteFileFolder.delete();

                      if (deleteFileFolder.errorMessage != null &&
                          context.mounted) {
                        _utils.showMessageError(
                          context,
                          message: deleteFileFolder.errorMessage!,
                        );
                      }

                      _loadListFolders();

                      _selectDisable();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),

                  onMore: (TapDownDetails position) async {
                    await _utils.showMenuDropUp(
                      context,
                      position: position,
                      onRename: () async {
                        final String path = widget.path ?? _path;

                        _selectDisable();

                        await _utils.showModalButtonSheetRename(
                          context,
                          size: size,
                          newNameController: _newNameController,
                          nameFile: _nameFile,
                          onCancel: () => Navigator.of(context).pop(),
                          onRename: () async {
                            final RenameFileFolder renameManager =
                                RenameFileFolder(
                                  isDirectory: _isDirectory,
                                  newName: _newNameController.text,
                                  path: path,
                                );

                            await renameManager.rename();

                            if (renameManager.errorMessage != null &&
                                context.mounted) {
                              _utils.showMessageError(
                                context,
                                message: renameManager.errorMessage!,
                              );
                            }

                            _newNameController.clear();
                            _loadListFolders();

                            if (context.mounted) Navigator.of(context).pop();
                          },
                        );
                        _loadListFolders();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
