import 'package:archify/constants/constants_value.dart';
import 'package:archify/ui/components/input_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:archify/constants/constants_color.dart';

class BoxCreateFolders extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function()? onCreateFolder;
  final Color? colorButtonCreateFolder;
  final TextEditingController? controller;

  const BoxCreateFolders({
    super.key,
    this.onChanged,
    this.onCreateFolder,
    this.colorButtonCreateFolder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      padding: EdgeInsets.only(left: 8, right: 8),
      margin: EdgeInsetsGeometry.only(top: 8, right: 8, left: 8),
      height: size.height * .13,
      width: size.width,
      duration: Duration(milliseconds: 550),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode.value
              ? AppColor.pupleColor
              : AppColor.blackColor.withAlpha(90),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(EvaIcons.folder_add_outline, color: AppColor.pupleColor),
              SizedBox(width: 8),
              Text(
                'Create New Folder',
                style: TextStyle(
                  color: isDarkMode.value
                      ? AppColor.whiteColor
                      : AppColor.pupleColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 550),
                  height: 45,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InputText(
                    color: isDarkMode.value
                        ? AppColor.whiteColor.withAlpha(90)
                        : AppColor.blackColorAlpha100,
                    hintText: 'Ex: Primeira semana',
                    controller: controller,
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: onCreateFolder,
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  height: 40,
                  width: 55,
                  decoration: BoxDecoration(
                    color: colorButtonCreateFolder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
