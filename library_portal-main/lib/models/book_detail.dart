// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Book {
  String imageUrl;
  String title;
  String author;
  String? publisher;
  String description;
  String id;
  int quantity;
  List<String> lentToUsers;

  Book({
    List<String>? lentToUsers,
    required this.imageUrl,
    required this.title,
    required this.author,
    this.publisher,
    required this.description,
    required this.id,
    required this.quantity,
  }) : lentToUsers = lentToUsers ?? [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'title': title,
      'author': author,
      'publisher': publisher,
      'description': description,
      'id': id,
      'quantity': quantity,
      'lentToUsers': lentToUsers,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      publisher: map['publisher'] != null ? map['publisher'] as String : null,
      description: map['description'] as String,
      id: map['id'] as String,
      quantity: map['quantity'] as int,
      lentToUsers: List<String>.from(
        (map['lentToUsers'] as List<dynamic>? ?? []),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source) as Map<String, dynamic>);
}
