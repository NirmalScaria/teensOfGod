import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teens_of_god/main.dart';

class Auth {
  Auth({required this.prefs});
  SharedPreferences prefs;
  bool isLoggedIn() {
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<String> signIn({String? emailId, String? password}) async {
    if (emailId == null ||
        password == null ||
        emailId == "" ||
        password == "") {
      return ("FAIL:EMPTY");
    }
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailId, password: password);
      if (credential.user != null) {
        prefs.setBool("isLoggedIn", true);
        prefs.setString("emailId", emailId);
        return (credential.user!.uid.toString());
      } else {
        return ("FAIL:NOUSER");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ("FAIL:NOUSER");
      } else if (e.code == 'wrong-password') {
        return ("FAIL:WRONGPASS");
      }
    }
    return ("FAIL");
  }

  void signOut(BuildContext context) {
    prefs.setBool("isLoggedIn", false);
    prefs.setString("emailId", "");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginRouter(),
        ),
        (route) => false);
  }
}
