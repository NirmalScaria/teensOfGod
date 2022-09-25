import 'package:flutter/material.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/views/home_page.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailId = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorMessage = "";
  bool isLoading = false;
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
          TextInput(
            label: "Email Address",
            controller: emailId,
          ),
          const SizedBox(height: 10),
          TextInput(
            label: "Password",
            isPassword: true,
            controller: password,
          ),
          const SizedBox(height: 10),
          if (errorMessage != "")
            Row(
              children: [
                const SizedBox(width: 30),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          if (errorMessage != "") const SizedBox(height: 10),
          PrimaryButton(
            text: "Sign in",
            isLoading: isLoading,
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              String authResponse = await auth!
                  .signIn(emailId: emailId.text, password: password.text);
              setState(() {
                isLoading = false;
              });
              if (authResponse.substring(0, 4) != "FAIL") {
                setState(() {
                  errorMessage = "";
                });
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                if (authResponse == "FAIL:EMPTY") {
                  setState(() {
                    errorMessage = "Please fill in all the fields";
                  });
                } else if (authResponse == "FAIL:NOUSER") {
                  setState(() {
                    errorMessage = "No user found with this email";
                  });
                } else if (authResponse == "FAIL:WRONGPASS") {
                  setState(() {
                    errorMessage = "Wrong password";
                  });
                } else {
                  setState(() {
                    errorMessage = "Please try again";
                  });
                }
              }
            },
          ),
        ],
      ),
    )));
  }
}
