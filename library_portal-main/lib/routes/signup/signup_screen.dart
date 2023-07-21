import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/signup/signup_controller.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupController(
        context.read(),
        context.read(),
      ),
      builder: (context, _) => const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(
      builder: (context, controller, _) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const LibraryAppBar(title: "Sign Up"),
        body: Form(
          key: controller.signupFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.w),
                Image.asset(
                  "assets/library.png",
                  width: 100.w,
                  height: 100.w,
                ),
                SizedBox(height: 30.w),
                TextField(
                  controller: controller.signupNameController,
                  decoration: const InputDecoration(label: Text("Name")),
                ),
                SizedBox(height: 15.w),
                TextField(
                  controller: controller.signupEmailController,
                  decoration: const InputDecoration(label: Text("Email")),
                ),
                SizedBox(height: 15.w),
                TextField(
                  obscureText: true,
                  controller: controller.signupPassController,
                  decoration: const InputDecoration(label: Text("Password")),
                ),
                SizedBox(height: 30.w),
                ElevatedButton(
                  onPressed: () {
                    controller.onSignup(
                      
                      controller.signupEmailController.text,
                      controller.signupPassController.text,
                      controller.signupNameController.text,
                      context,
                    );
                  },
                  child: const Text("Sign Up"),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
