import 'package:flutter/material.dart';

class StudentIdScreen extends StatefulWidget {
  StudentIdScreen({ Key? key , required this.generatedUid}) : super(key: key);
  String generatedUid;

  @override
  State<StudentIdScreen> createState() => _StudentIdScreenState();
}

class _StudentIdScreenState extends State<StudentIdScreen> {
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