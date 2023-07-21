import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/firebase_options.dart';
import 'package:library_portal_app/services/firebase_service.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';
import 'package:library_portal_app/routes/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (error) {
    print(error);
    debugPrintStack();
  };
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) {
      print(error);
      debugPrintStack(stackTrace: stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    SizeConfig.init();
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseService()),
        ChangeNotifierProvider(create: (context) => UserService(context.read())),
        ChangeNotifierProvider(create: (context) => LibraryService(context.read(), context.read())),
      ],
      child: MaterialApp(
        title: "Library Portal App",
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: SizeConfig.getMediaQuery(context),
            child: child!,
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.brown,
          focusColor: Colors.brown[100],
          scaffoldBackgroundColor: ColorConfig.gradientColor,
          textTheme: const TextTheme(),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
            tileColor: Colors.brown,
            textColor: Colors.white,
            visualDensity: VisualDensity.standard,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(color: ColorConfig.gradientColor),
            ),
          ),
        ),
        home: const SplashRoute(),
      ),
    );
  }
}
