import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/routes/book_detail/borrowed_by_users.dart';
import 'package:library_portal_app/routes/book_detail/lend_to_user.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';
import 'package:library_portal_app/utils/snackbar.dart';
import 'package:library_portal_app/utils/utils.dart';

import '../../models/library_user.dart';

class BookDetailController extends ChangeNotifier {
  final LibraryService _libraryService;
  final UserService _userService;
  final Book _book;

  BookDetailController(this._libraryService, this._userService, this._book) {
    _userService.addListener(onUserUpdate);
  }

  void onUserUpdate() {
    notifyListeners();
  }

  bool get isAdmin => _userService.user?.isAdmin ?? false;
  Book get bookData => _book;

  bool isLoading = false;

  void lendToUser(BuildContext context) async {
    final user = await RouteNavigation.push<LibraryUser>(context, LendToUser());
    if (user != null) {
      void showError(e) => SnackbarUtils.error(context, e.toString());
      void showSuccess(String msg) => SnackbarUtils.success(context, msg);
      try {
        await _libraryService.lendBookToUser(bookData, user);
        showSuccess("Book was borrowed by user ${user.name} successfully");
      } catch (e) {
        showError(e);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userService.removeListener(onUserUpdate);
  }

  void checkBookUser(BuildContext context) {
    RouteNavigation.push(
      context,
      BorrowedByUsers(book: bookData),
    );
  }

  void deleteBook(BuildContext context) async {
    final result = await Utils.showConfirmationDialog(context);
    if (result == true) {
      isLoading = true;
      notifyListeners();

      try {
        success() {
          SnackbarUtils.success(context, "Book deleted successfully");
          Navigator.of(context).pop();
        }

        await _libraryService.deleteBook(bookData);
        success();
      } catch (e) {
        SnackbarUtils.error(context, e.toString());
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
