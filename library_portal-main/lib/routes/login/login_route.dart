import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/library_dashboard/library_dashboard.dart';
import 'package:library_portal_app/routes/signup/signup_screen.dart';
import 'package:library_portal_app/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:library_portal_app/utils/snackbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginRoute extends StatefulWidget {
  LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(height: 50.w),
              Image.asset(
                'assets/library.png',
                width: 150.w,
                height: 150.w,
              ),
              SizedBox(height: 20.w),
              Form(
                  key: formKey,
                  child: SizedBox(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                            //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,color: ColorConfig.borderColor))
                          ),
                        ),
                        SizedBox(height: 30.w),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text("Password"),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 30.w),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        isLoading = true;
                        setState(() {});
                        void navigateToDashboard() => RouteNavigation.pushReplacement(context, const LibraryDashboard());
                        await context.read<UserService>().login(usernameController.text, passwordController.text);
                        isLoading = false;
                        setState(() {});
                        navigateToDashboard();
                      } catch (e) {
                        isLoading = false;
                        setState(() {});
                        SnackbarUtils.error(
                          context,
                          e.toString(),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "LogIn",
                  )),
              ElevatedButton(
                  onPressed: () {
                    RouteNavigation.push(context, const LibraryDashboard(isGuestUser: true));
                  },
                  child: const Text(
                    "Guest User",
                  )),
              SizedBox(height: 30.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      RouteNavigation.push(context, const SignupScreen());
                    },
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context, String alertText) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(
              "Error",
            ),
            content: Builder(builder: (context) {
              return SizedBox(
                height: 150.w,
                width: 300.w,
                child: Center(
                  child: Text(
                    alertText,
                  ),
                ),
              );
            }),
            actions: [
              ElevatedButton(
                child: const Text("Retry"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
