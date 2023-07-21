import 'package:flutter/foundation.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/services/firebase_service.dart';
import 'package:library_portal_app/services/user_service.dart';

class LibraryService extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final UserService _userService;

  LibraryService(this._firebaseService, this._userService);

  List<Book>? books;
  bool isLoading = true;
  String? error;

  Future<void> init() async {
    try {
      isLoading = true;
      notifyListeners();
      books = await _firebaseService.getBooks();
      notifyListeners();
      _firebaseService.getBooksStream.map<List<Book>>(
        (snapshot) {
          final books = <Book>[];
          for (int i = 0; i < snapshot.docs.length; i++) {
            final bookData = snapshot.docs[i].data();
            Book book = Book.fromMap(bookData);
            books.add(book);
          }
          return books;
        },
      ).listen((event) {
        books = event;
        isLoading = false;
        notifyListeners();
      });
      isLoading = false;
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      error = "Error while loading books";
      isLoading = false;
    }
  }

  /* Future<void> bookAddition(Book book ,Uint8List imageUrl){

  }*/

  Future<void> lendBookToUser(Book book, LibraryUser user) async {
    try {
      await _firebaseService.lendBook(book.id, user.id);
      if (!book.lentToUsers.contains(user.id)) {
        book.lentToUsers.add(user.id);
      }
      if (!user.borrowedBooks.contains(book.id)) {
        user.borrowedBooks.add(book.id);
      }
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Couldn't complete the action, try again";
    }
  }

  List<LibraryUser> getBookBorrowers(Book book) {
    final users = <LibraryUser>[];
    for (int i = 0; i < book.lentToUsers.length; i++) {
      final uid = book.lentToUsers[i];
      LibraryUser user = _userService.allUsers!.firstWhere((element) => element.id == uid);
      users.add(user);
    }
    return users;
  }

  Future<List<Book>> getUsersBooks(LibraryUser user) async {
    final userBooks = <Book>[];
    if (books != null && books!.isNotEmpty) {
      for (int i = 0; i < user.borrowedBooks.length; i++) {
        for (int j = 0; j < books!.length; j++) {
          if (user.borrowedBooks[i] == books![j].id) {
            userBooks.add(books![j]);
          }
        }
      }
      return userBooks;
    } else {
      return userBooks;
    }
  }

  Future<void> updateOrCreateBook(Book book, Uint8List cover) async {
    try {
      await _firebaseService.updateOrCreateBook(book, cover);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      if (e is String) {
        rethrow;
      } else {
        throw "Failed to upload book, try again";
      }
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      await _firebaseService.deleteBook(book);
      books?.remove(book);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Unable to delete book! try again";
    }
  }

  Future<void> returnBook(Book book, LibraryUser user) async {
    try {
      await _firebaseService.returnBook(book, user);
      book.lentToUsers.remove(user.id);
      user.borrowedBooks.remove(book.id);
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw "Unable to update data";
    }
  }
}
