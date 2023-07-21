// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/routes/library_dashboard/library_dashboard.dart';

import 'package:library_portal_app/services/firebase_service.dart';
import 'package:library_portal_app/services/user_service.dart';

class SignupController extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final UserService _userService;
  SignupController(
    this._firebaseService,
    this._userService,
  );
  final signupFormKey = GlobalKey<FormState>();
  final signupEmailController = TextEditingController();
  final signupNameController = TextEditingController();
  final signupPassController = TextEditingController();

  void onSignup(String email, String password, String name,BuildContext context) async {
    

    await _userService.signup(name, email, password);

    RouteNavigation.pushReplacement(
        context,
        LibraryDashboard(
          isGuestUser: false,
        ));
  }
}
