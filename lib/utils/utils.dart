import 'package:archify/ui/components/box_paths.dart';
import 'package:archify/ui/components/bt_confirm_or_cancell.dart';
import 'package:archify/ui/components/input_text.dart';
import 'package:flutter/material.dart';
import 'package:archify/constants/constants_color.dart';
import 'package:intl/intl.dart';

class Utils {
  void showMessageError(BuildContext context, {required String message}) {
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

  Future<void> showModalButtonSheetRename(
    BuildContext context, {
    required String nameFile,
    required Size size,
    required TextEditingController? newNameController,
    required void Function()? onRename,
    required void Function()? onCancel,
  }) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 12),
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        height: size.height * .25,
        width: size.width,
        decoration: BoxDecoration(
          color: Color(0xff232323),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              'Renomear',
              style: TextStyle(color: AppColor.whiteColor, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              'Insira um novo nome',
              style: TextStyle(color: AppColor.whiteColor, fontSize: 15),
            ),
            SizedBox(height: 15),
            InputText(
              color: Colors.white.withAlpha(90),
              styleTextColor: AppColor.whiteColor,
              controller: newNameController,
              onChanged: (String? newName) {},
              hintText: nameFile,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtConfirmOrCancell(
                  onTap: onCancel,
                  text: 'Cancelar',
                  color: AppColor.whiteColor,
                ),
                BtConfirmOrCancell(
                  onTap: onRename,
                  text: 'Renomear',
                  color: AppColor.orangerColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String setFormatHour(DateTime dateTime) {
    String formatData = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formatData;
  }

  void goToRoutePageWithOutAnimation(
    BuildContext context, {
    required Widget route,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => route,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void goToRoutePage(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
  }) {
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  List<Widget> sliderAnimationPath(
    List<String>? list,
    Animation<Offset>? animation,
  ) {
    return list![1].split('/').asMap().entries.map((entry) {
      final int index = entry.key;
      final String value = entry.value;

      if (value.isEmpty) return Container();

      final bool isLast = index == list[1].split('/').length - 1;

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
