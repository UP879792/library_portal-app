import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/providers/app_provider.dart';
import 'package:library_portal_app/services/firebase_service.dart';

class UserService extends ChangeNotifier {
  final FirebaseService _firebaseService;

  UserService(this._firebaseService);

  LibraryUser? _libraryUser;

  LibraryUser? get user => _libraryUser;
  List<LibraryUser>? allUsers;

  String? error;
  bool isLoading = true;

  bool get isLoggedIn => user != null;

  Future<void> init() async {
    if (_firebaseService.isLoggedIn) {
      try {
        await _loadUser(_firebaseService.firebaseUser!.uid);
        AppProvider.initUserServices(this);
      } catch (_) {}
    }
  }

  Future<void> initializeUsers() async {
    if (!user!.isAdmin) {
      error = "Only admin is allowed to get other users data";
    } else {
      try {
        isLoading = true;
        notifyListeners();
        allUsers = await _firebaseService.getUsers();
        _firebaseService.getUsersStream.map<List<LibraryUser>>((snapshot) {
          final users = <LibraryUser>[];
          for (int i = 0; i < snapshot.docs.length; i++) {
            final doc = snapshot.docs[i];
            final docData = doc.data();
            final user = LibraryUser.fromMap(docData);
            users.add(user);
          }
          return users;
        }).listen((users) {
          allUsers = users;
          notifyListeners();
        });
        isLoading = false;
        notifyListeners();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        error = "Unable to load users";
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final userCredentials = await _firebaseService.signup(email, password);
      if (userCredentials.user != null) {
        final user = LibraryUser(
          id: userCredentials.user!.uid,
          email: email,
          name: name,
          borrowedBooks: [],
        );
        await _firebaseService.updateOrCreateUser(user);
        _libraryUser = user;
        AppProvider.initUserServices(this);
      } else {
        throw "Couldn't create user";
      }
    } on FirebaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      if (e.code == 'email-already-in-use') {
        throw "User already exists! Please Login";
      } else if (e.code == 'invalid-email') {
        throw "Your email is invalid! Please check";
      }
      throw "Failed to create user profile";
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Failed to create user profile";
    }
  }

  Future<LibraryUser> _loadUser(String uid) async {
    final doc = await _firebaseService.getUser(uid);
    if (doc == null) {
      await _firebaseService.deleteUser();
      throw "Your signup process was interrupted. Please signup again!";
    } else {
      _libraryUser = LibraryUser.fromMap(doc);
      notifyListeners();
      return _libraryUser!;
    }
  }

  Future<LibraryUser> login(String email, String password) async {
    try {
      final userCrendentials = await _firebaseService.login(email, password);
      if (userCrendentials.user != null) {
        await _loadUser(userCrendentials.user!.uid);
        AppProvider.initUserServices(this);
        return _libraryUser!;
      } else {
        throw "Invalid email or password";
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Invalid email or password";
    }
  }

  Future<void> updateUser(LibraryUser user) async {
    try {
      await _firebaseService.updateOrCreateUser(user);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Failed to update user profile";
    }
  }

  Future<void> logout() async {
    try {
      _firebaseService.logout();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Unable to signout, please try again";
    }
  }
}
