import 'package:flutter/material.dart';
import 'package:rockid/pages/auth_page.dart';
import 'pages/login_page.dart';
<<<<<<< HEAD
import 'pages/home_page.dart';
=======
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
>>>>>>> db79a9fcd79e6558b22ca49ab2a5323305e38d69

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home: HomePage(),
=======
      home: AuthPage(),
>>>>>>> db79a9fcd79e6558b22ca49ab2a5323305e38d69
    );
  }
}
