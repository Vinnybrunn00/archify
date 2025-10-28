import 'package:archify/ui/components/bt_options_archive.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BoxOptionsArchive extends StatelessWidget {
  final Matrix4? transform;
  final bool? isDirectory;
  final void Function()? onShare;
  final void Function()? onDelete;
  final void Function(TapDownDetails)? onMore;
  final void Function()? onMove;

  const BoxOptionsArchive({
    super.key,
    this.transform,
    this.isDirectory,
    this.onShare,
    this.onDelete,
    this.onMore,
    this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        height: size.height * .08,
        width: size.width,
        duration: Duration(milliseconds: 680),
        color: Color(0xff232323),
        curve: Curves.easeIn,
        transform: transform,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BtOptionsArchive(
              onTap: onMove,
              title: 'Move',
              iconData: Bootstrap.folder_symlink,
            ),

            BtOptionsArchive(
              isDirectory: isDirectory,
              title: 'Share',
              onTap: onShare,
              iconData: BoxIcons.bx_share,
            ),

            BtOptionsArchive(
              title: 'Delete',
              onTap: onDelete,
              iconData: FontAwesome.trash_can,
            ),

            BtOptionsArchive(
              onTapDown: onMore,
              title: 'More',
              iconSize: 20,
              iconData: Iconsax.more_square_outline,
            ),
          ],
        ),
      ),
    );
  }
}
