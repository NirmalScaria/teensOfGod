import 'package:flutter/material.dart';

class VolunteerIdScreen extends StatefulWidget {
  VolunteerIdScreen({ Key? key , required this.generatedUid}) : super(key: key);
  String generatedUid;

  @override
  State<VolunteerIdScreen> createState() => _VolunteerIdScreenState();
}

class _VolunteerIdScreenState extends State<VolunteerIdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(widget.generatedUid),
      ),
    );
  }
}