import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/providers/app_provider.dart';
import 'package:library_portal_app/routes/library_dashboard/library_dashboard.dart';
import 'package:library_portal_app/routes/login/login_route.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';

class SplashController extends ChangeNotifier {
  final LibraryService _libraryService;
  final UserService _userService;
  final NavigatorState state;
  SplashController(
    this._libraryService,
    this._userService,
    this.state,
  ) {
    init();
  }

  String? error;

  Future<void> init() async {
    error = null;
    notifyListeners();
    final result = await AppProvider.initGlobalServices(_libraryService, _userService);

    if (!result) {
      error = "Unable to load data";
    } else {
      error = null;
      bool isLoggedIn = _userService.isLoggedIn;
      if (isLoggedIn) {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => RouteNavigation.pushReplacement(
            state.context,
            const LibraryDashboard(),
            state: state,
          ),
        );
      } else {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => RouteNavigation.pushReplacement(
            state.context,
            LoginRoute(),
            state: state,
          ),
        );
      }
    }

    notifyListeners();
  }
}
