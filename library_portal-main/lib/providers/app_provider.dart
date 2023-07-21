import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';

class AppProvider {
  static Future<void> initUserServices(UserService userService) async {
    await userService.initializeUsers();
  }

  static Future<bool> initGlobalServices(LibraryService libraryService, UserService userService) async {
    try {
      Completer completer = Completer();
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) async {
          try {
            if (libraryService.books == null || libraryService.books!.isEmpty) {
              await libraryService.init();
            }
            if (userService.user == null) {
              await userService.init();
            }
          } catch (e) {
            completer.completeError(e);
            return;
          }
          completer.complete();
        },
      );
      await completer.future;
      return true;
    } catch (e, s) {
      return false;
    }
  }
}
