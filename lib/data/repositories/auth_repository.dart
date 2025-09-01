import 'package:chrono_point/data/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  // Mendapatkan stream status autentikasi pengguna
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // Fungsi untuk Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Simpan data tambahan ke Firestore
      if (userCredential.user != null) {
        Users newUser = Users(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());

        await _firebaseAuth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi untuk Sign In
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Fungsi untuk Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
