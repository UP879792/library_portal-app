import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';

class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? action;
  const LibraryAppBar({super.key, this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        action == null ? SizedBox(width: 50.w) : action!,
      ],
      backgroundColor: ColorConfig.primaryColor,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(color: ColorConfig.gradientColor),
            )
          : Icon(
              Icons.library_books,
              size: 40.w,
            ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.w);
}
