import 'package:flutter/material.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/widgets/buttons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
     child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
              onPressed: () {
                auth!.signOut(context);
              },
              text: "Log out")
        ],
      ),
    )
    );
  }
}