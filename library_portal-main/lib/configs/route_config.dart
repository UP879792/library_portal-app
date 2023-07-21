import 'package:flutter/cupertino.dart';

class RouteNavigation {
  static pushReplacement(
    BuildContext context,
    Widget route, {
    NavigatorState? state,
    String? name,
    dynamic arguments,
  }) {
    (state ?? Navigator.of(context)).pushReplacement(
      CupertinoPageRoute(
        builder: (context) {
          return route;
        },
        settings: RouteSettings(
          name: name,
          arguments: arguments,
        ),
      ),
    );
  }

  static Future<T?> push<T>(
    BuildContext context,
    Widget route, {
    NavigatorState? state,
    String? name,
    dynamic arguments,
  }) {
    return (state ?? Navigator.of(context)).push(
      CupertinoPageRoute(
        builder: (context) {
          return route;
        },
        settings: RouteSettings(
          name: name,
          arguments: arguments,
        ),
      ),
    );
  }
}
