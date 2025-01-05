import 'package:exportsandchardg10/firebase_options.dart';
import 'package:exportsandchardg10/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
