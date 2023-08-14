import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthFunc {
  Future<String> signIn(String? email, String? password);

  Future<User?> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signedOut();
  Future<bool> isEmailVerified();
  Future<void> sendPasswordReset(String email);
  Future<void> sendPasswordResetEmail(String email);
}

class MyAuth implements AuthFunc {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  Future<User?> getCurrentUser() async {
    initFirebase();
    return await _firebaseAuth.currentUser;
  }

  @override
  Future<void> sendEmailVerification() async {
    initFirebase();

    var user = await _firebaseAuth.currentUser!;

    user.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    initFirebase();

    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future sendPasswordResetEmail(String email) async {
    initFirebase();

    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<String> signIn(String? email, String? password) async {
    var user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email!, password: password!))
        .user!;
    return user.uid;
  }

  @override
  Future<void> signedOut() async {
    initFirebase();

    return await _firebaseAuth.signOut();
  }

  Future<String> signUp(String email, String password) async {
    initFirebase();

    final FirebaseAuth _auth = FirebaseAuth.instance;

    User? user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password)) as User;
    } catch (e) {} finally {
      if (user != null) {
      } else {}
    }
    return user!.uid;
  }

  @override
  Future<bool> isEmailVerified() async {
    initFirebase();

    var user = await _firebaseAuth.currentUser!;
    return user.emailVerified;
  }
}
