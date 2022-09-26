import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  TextInput({Key? key, required this.label, this.isPassword, required this.controller, this.padding}) : super(key: key);
  final String label;
  bool? isPassword = false;
  final controller;
  int? padding = 30;
  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - ((widget.padding ?? 30) * 2),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ?? false,
          enableSuggestions: !(widget.isPassword ?? false),
          autocorrect: !(widget.isPassword ?? false),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(widget.label),
            hintText: widget.label,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
        ));
  }
}
