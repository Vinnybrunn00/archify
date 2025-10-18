import 'dart:io';
import 'dart:math';

import 'package:archify/ui/components/box_paths.dart';
import 'package:archify/ui/components/bt_confirm_or_cancell.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';
import 'package:archify/core/models/file_types.dart';
import 'package:intl/intl.dart';

class Utils {
  String showFileSystemException(String message) {
    switch (message) {
      case 'Cannot open file':
        return 'Arquivo não pode ser aberto.';
      case 'Cannot create file':
        return 'Arquivo não pode ser criado';
      case 'Cannot delete file':
        return 'Arquivo não pode ser deletado';
      case 'Cannot copy file':
        return 'Arquivo não pode ser copiado';
      case 'Cannot rename file' || 'Rename failed':
        return 'Arquivo não pode ser renomeado';
      case 'Cannot open directory':
        return 'Pasta não pode ser aberta';
      case 'Cannot create directory':
        return 'Pasta não pode ser criada';
      case 'Cannot delete directory':
        return 'Pasta não pode ser deletada';
      case 'Cannot copy directory':
        return 'Pasta não pode ser copiada';
      case 'Operation failed':
        return 'Operação falha';
      case 'Not a directory':
        return 'Isso não é um diretório';
      case 'File exists':
        return 'Arquivo existente.';
      case 'No such file or directory':
        return 'Não existe tal arquivo ou diretório';
      case 'Permission denied':
        return 'Você não tem permissão para executar esta ação';
      case 'Device or resource busy':
        return 'Dispositivo ou recurso ocupado';
      case 'No space left on device':
        return 'Não há espaço disponível no dispositivo';
      case 'Text file busy':
        return 'Arquivo de texto ocupado';
      default:
        return 'Invalid argument';
    }
  }

  void showScaffoldMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 200,
        content: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Color(0xff0D1117),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(message)),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Future<void> showMenuDropUp(
    BuildContext context, {
    required TapDownDetails position,
    required void Function()? onRename,
  }) async {
    await showMenu(
      color: Color(0xff232323),
      position: RelativeRect.fromLTRB(
        position.globalPosition.dx,
        position.globalPosition.dy - 140,
        0,
        0,
      ),
      context: context,
      items: [
        PopupMenuItem(
          onTap: onRename,
          value: 'Renomear',
          child: Text(
            'Renomear',
            style: TextStyle(color: Colors.white.withAlpha(220)),
          ),
        ),
      ],
    );
  }

  Widget? leading(
    FileSystemEntityType statsType,
    File file,
    FileTypes fileTypes,
  ) {
    switch (statsType) {
      case FileSystemEntityType.file:
        if (fileTypes.isAudio) {
          return Icon(
            EvaIcons.music_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }

        if (fileTypes.isVideo) {
          return Icon(
            EvaIcons.video_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }

        if (fileTypes.isText) {
          return Icon(
            EvaIcons.text_outline,
            color: AppColor.pupleColor,
            size: 22,
          );
        }
        if (fileTypes.isPdf) {
          return Icon(
            FontAwesome.file_pdf,
            color: AppColor.pupleColor,
            size: 19,
          );
        }
      case FileSystemEntityType.directory:
        return Icon(
          Icons.folder_outlined,
          color: AppColor.pupleColor,
          size: 22,
        );
      default:
        return Icon(
          EvaIcons.question_mark,
          color: AppColor.pupleColor,
          size: 22,
        );
    }
    return Icon(Icons.file_open_outlined, color: AppColor.pupleColor, size: 22);
  }

  String setFormatHour(DateTime dateTime) {
    String formatData = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    return formatData;
  }

  String formatBytes(int? bytes, {int decimals = 2, bool useSI = false}) {
    if (bytes == null) return '0 B';
    if (bytes < 0) {
      return '-${formatBytes(-bytes, decimals: decimals, useSI: useSI)}';
    }
    if (bytes == 0) return '0 B';

    final base = useSI ? 1000 : 1024;
    final suffixes = useSI
        ? ['B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    final i = min((log(bytes) / log(base)).floor(), suffixes.length - 1);

    final value = bytes / pow(base, i);
    return '${value.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void goToRoutePage(BuildContext context, {required Widget route}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => route,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  List<Widget> sliderAnimationPath(
    List<String>? list,
    Animation<Offset>? animation,
  ) {
    return list![1].split('/').asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;

      if (value.isEmpty) return Container();

      bool isLast = index == list[1].split('/').length - 1;

      return Row(
        children: [
          isLast
              ? SlideTransition(
                  position: animation!,
                  child: BoxPaths(
                    element: value,
                    color: isLast ? AppColor.orangerColor : null,
                  ),
                )
              : BoxPaths(
                  element: value,
                  color: isLast ? AppColor.orangerColor : null,
                ),

          isLast ? Container() : Icon(Icons.keyboard_arrow_right, size: 13),
        ],
      );
    }).toList();
  }

  Future<void> showModal(
    BuildContext context, {
    required Size size,
    required void Function()? onDelete,
  }) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      requestFocus: true,
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (context) => AnimatedContainer(
        margin: EdgeInsets.only(bottom: 25),
        padding: EdgeInsets.only(top: 8, bottom: 8),
        duration: Duration(milliseconds: 550),
        height: size.height * .25,
        width: size.width * .9,
        decoration: BoxDecoration(
          color: AppColor.blackBlueLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Excluir?',
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Exluir este arquivo?',
              style: TextStyle(color: AppColor.whiteColor, fontSize: 15),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BtConfirmOrCancell(
                  onTap: () => Navigator.of(context).pop(),
                  text: 'Cancelar',
                  color: AppColor.whiteColor,
                ),
                BtConfirmOrCancell(
                  onTap: onDelete,
                  text: 'Excluir',
                  color: AppColor.redColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
