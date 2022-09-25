import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  TextInput({Key? key, required this.label, this.isPassword, required this.controller}) : super(key: key);
  final String label;
  bool? isPassword = false;
  final controller;
  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ?? false,
          enableSuggestions: !(widget.isPassword ?? false),
          autocorrect: !(widget.isPassword ?? false),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.label,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
        ));
  }
}
