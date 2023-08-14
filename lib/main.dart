import 'package:adocao/screens/utils/firebase_auth_utils.dart';
import 'package:adocao/screens/utils/mapping_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ineed Help',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MappingPage(
        auth: new MyAuth(),
      ),
    );
  }
}
