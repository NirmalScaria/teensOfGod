import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teens_of_god/models/auth.dart';
import 'package:teens_of_god/views/home_page.dart';
import 'package:teens_of_god/views/welcome_page.dart';
import 'package:teens_of_god/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    auth = Auth(prefs: prefs);
    return MaterialApp(
      title: 'Teens Of God',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFAD8E1C, color),
      ),
      home: const LoginRouter(),
    );
  }
}

class LoginRouter extends StatelessWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (auth!.isLoggedIn()) {
      return (const HomePage());
    } else {
      return (const WelcomePage());
    }
  }
}
