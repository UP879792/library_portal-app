import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/splash_screen/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashRoute extends StatelessWidget {
  const SplashRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashController(
        context.read(),
        context.read(),
        Navigator.of(context),
      ),
      child: _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, controller, _) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/library.png',
                  width: 150.w,
                ),
              ),
              if (controller.error != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                    data: ThemeData(
                      listTileTheme: const ListTileThemeData(
                        tileColor: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.w),
                      child: ListTile(
                        title: Text(
                          controller.error!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: controller.init,
                          child: const Text(
                            "Reload",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        style: ListTileStyle.list,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
