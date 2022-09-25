import 'package:flutter/material.dart';
import 'package:teens_of_god/views/login_page.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/texts.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
          BigTitle(text: "Hey! Welcome"),
          const SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Description(
                  text:
                      "We are pleased to have you as a mentor. Please login to continue.")),
          const SizedBox(height: 30),
          PrimaryButton(
              onPressed: () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    ))
                  },
              text: "Sign in"),
          const SizedBox(height: 10),
          SecondaryButton(
              onPressed: () => {_launchUrl()}, text: "Join as a new mentor")
        ],
      ),
    )));
  }
}

Future<void> _launchUrl() async {
  final Uri _url = Uri.parse('https://teensofgod.org/');
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
