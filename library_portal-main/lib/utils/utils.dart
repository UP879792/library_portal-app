import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';

class Utils {
  static Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
            "Are you sure you want delete this book? This action is not reversable",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: ColorConfig.errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
