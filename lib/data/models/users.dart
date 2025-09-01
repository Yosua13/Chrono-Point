import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final String uid;
  final String email;
  final String name;

  const Users({required this.uid, required this.email, required this.name});

  // Konversi dari DocumentSnapshot Firebase ke Users
  factory Users.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return Users(uid: snap.id, email: data['email'], name: data['name']);
  }

  // Konversi dari Users ke Map untuk disimpan di Firebase
  Map<String, dynamic> toJson() => {'email': email, 'name': name};

  @override
  List<Object> get props => [uid, email, name];
}
