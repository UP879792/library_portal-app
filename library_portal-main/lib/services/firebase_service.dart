import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  late CollectionReference<Map<String, dynamic>> booksReference;
  late CollectionReference<Map<String, dynamic>> usersReference;

  FirebaseService() {
    booksReference = _firestore.collection('books');
    usersReference = _firestore.collection('users');
  }

  Future<UserCredential> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signup(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> updateOrCreateUser(LibraryUser user) {
    return usersReference.doc(_auth.currentUser!.uid).set(
      {'name': user.name, 'email': user.email, 'isAdmin': user.isAdmin, 'id': user.id, 'borrowedBooks': user.borrowedBooks},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await usersReference.doc(uid).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _auth.currentUser!.delete();
  }

  Future<String> uploadBookImage(Uint8List data, String name) async {
    final bookRef = _storage.ref().child('books/$name.png');
    final task = await bookRef.putData(data);
    if (task.state == TaskState.success) {
      String url = await bookRef.getDownloadURL();
      return url;
    } else {
      throw "Failed to upload book image";
    }
  }

  Future<void> updateOrCreateBook(Book book, Uint8List image) async {
    book.imageUrl = await uploadBookImage(image, book.title);

    return booksReference.doc(book.id).set(
          book.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteBook(Book book) async {
    final batch = _firestore.batch();
    for (int i = 0; i < book.lentToUsers.length; i++) {
      final uid = book.lentToUsers[i];
      batch.update(
        usersReference.doc(uid),
        {
          "borrowedBooks": FieldValue.arrayRemove(
            [book.id],
          ),
        },
      );
    }
    batch.delete(booksReference.doc(book.id));
    return batch.commit();
  }

  Future<void> lendBook(String bookId, String uid) async {
    final batch = _firestore.batch();

    final bookref = booksReference.doc(bookId);
    final userref = usersReference.doc(uid);

    batch.update(
      bookref,
      {
        'quantity': FieldValue.increment(-1),
        'lentToUsers': FieldValue.arrayUnion([uid]),
      },
    );
    batch.update(userref, {
      'borrowedBooks': FieldValue.arrayUnion([bookId]),
    });
    await batch.commit();
  }

  Future<List<Book>?> getBooks() async {
    final snapshot = await booksReference.get();
    final books = <Book>[];
    for (int i = 0; i < snapshot.docs.length; i++) {
      final bookData = snapshot.docs[i].data();
      Book book = Book.fromMap(bookData);
      books.add(book);
    }
    return books;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getBooksStream => booksReference.snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get getUsersStream => usersReference.snapshots();

  Future<List<LibraryUser>> getUsers() async {
    final snapshot = await usersReference.get();
    final users = <LibraryUser>[];
    for (int i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      final docData = doc.data();
      final user = LibraryUser.fromMap(docData);
      users.add(user);
    }
    return users;
  }

  bool get isLoggedIn => _auth.currentUser != null;
  User? get firebaseUser => _auth.currentUser;

  Future<void> logout() async {
    return _auth.signOut();
  }

  Future<void> returnBook(Book book, LibraryUser user) async {
    final batch = _firestore.batch();
    final userRef = usersReference.doc(user.id);
    final bookRef = booksReference.doc(book.id);
    batch.update(
      userRef,
      {
        "borrowedBooks": FieldValue.arrayRemove([book.id]),
      },
    );
    batch.update(
      bookRef,
      {
        "lentToUsers": FieldValue.arrayRemove([user.id]),
        "quantity": FieldValue.increment(-1),
      },
    );
    await batch.commit();
  }
}
