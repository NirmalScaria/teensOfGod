import 'package:flutter/material.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/togLogo.png',
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          const SizedBox(height: 20),
          BigTitle(text: "Please sign in to\n continue"),
          const SizedBox(height: 30),
          TextInput(label: "Email Address"),
          const SizedBox(height: 10),
          TextInput(label: "Password", isPassword: true,),
          const SizedBox(height: 10),
          PrimaryButton(
              onPressed: () => {
                   // TODO: Implement login routing 
                  },
              text: "Sign in"),
          const SizedBox(height: 10),
        ],
      ),
    )));
  }
}
