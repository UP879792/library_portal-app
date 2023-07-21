import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';

class SnackbarUtils {
  static void error(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: ColorConfig.errorColor,
      ),
    );
  }
  static void success(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: ColorConfig.green,
      ),
    );
  }
}
