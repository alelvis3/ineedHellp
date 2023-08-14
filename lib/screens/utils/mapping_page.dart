import 'package:adocao/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import '../home_screen.dart';
import 'firebase_auth_utils.dart';

class MappingPage extends StatefulWidget {
  final AuthFunc? auth;

  MappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

void initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String? id;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    initFirebase();
    // TODO: implement initState
    super.initState();

    widget.auth!.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus = firebaseUserId == null
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });

    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = await auth.currentUser;

    if (user != null) {
      if (user.uid.isNotEmpty) {
        id = user.uid;
      }
    }
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginScreen(

            // auth: widget.auth,
            // onSignedIn: _signedIn,

            );

      case AuthStatus.signedIn:
        return new HomeScreen(
          auth: widget.auth,
          signedOut: _signedOut,
          userId: id,
        );
    }

    // return null;
  }
}
