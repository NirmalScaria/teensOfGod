import 'package:flutter/material.dart';
import 'package:teens_of_god/widgets/buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
          PrimaryButton(onPressed: () => {}, text: "HI")
        ],
      ),
    )));
  }
}
