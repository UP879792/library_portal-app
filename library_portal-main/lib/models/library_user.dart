// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LibraryUser {
  String id;
  String email;
  String name;
  bool isAdmin;
  List<String> borrowedBooks;
  LibraryUser({
    required this.id,
    required this.email,
    required this.name,
    required this.borrowedBooks,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'isAdmin': isAdmin,
      'borrowedBooks': borrowedBooks,
    };
  }

  factory LibraryUser.fromMap(Map<String, dynamic> map) {
    return LibraryUser(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      isAdmin: map['isAdmin'] as bool? ?? false,
      borrowedBooks: List<String>.from((map['borrowedBooks'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory LibraryUser.fromJson(String source) => LibraryUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
