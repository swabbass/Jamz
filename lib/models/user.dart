import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String? username;
  final String? email;
  final String? photoUrl;
  final String? bio;

  AppUser({
    required this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.bio,
  });
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
    );
  }
}
