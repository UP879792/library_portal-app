import 'package:flutter/material.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';

class AccountManagementController extends ChangeNotifier {
  final UserService _userService;
  final LibraryService _libraryService;

  AccountManagementController(this._userService, this._libraryService) {
    getBorrowedBooks();
  }

  LibraryUser get user => _userService.user!;

  List<Book> borrowedBooks = [];

  bool loading = true;

  void getBorrowedBooks() async {
    loading = true;
    notifyListeners();
    if (user.borrowedBooks.isNotEmpty) {
      final userBooks = await _libraryService.getUsersBooks(user);
      if (userBooks.isNotEmpty) {
        borrowedBooks = userBooks;
        loading = false;
        notifyListeners();
      }
    }
  }
}
