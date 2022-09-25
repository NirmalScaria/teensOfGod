import 'package:flutter/material.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/widgets/buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: const Text("Home")),
          PrimaryButton(
              onPressed: () {
                auth!.signOut(context);
              },
              text: "Log out")
        ],
      ),
    ));
  }
}
