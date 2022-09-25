import 'package:flutter/material.dart';
import 'package:teens_of_god/models/auth.dart';
import 'package:teens_of_god/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teens Of God',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginRouter(),
    );
  }
}

class LoginRouter extends StatelessWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    auth authObject = auth();
    if (authObject.isLoggedIn()) {
      return (LoginPage());
    } else {
      return (LoginPage());
    }
  }
}
