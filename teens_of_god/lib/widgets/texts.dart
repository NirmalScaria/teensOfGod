import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatefulWidget {
  Description({
    Key? key,
    required this.text,
    this.align = TextAlign.center,
    this.color = const Color(0xff9d9d9d),
  }) : super(key: key);
  String text;
  TextAlign align = TextAlign.center;
  Color color = Color(0xff9d9d9d);
  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.align,
      style: GoogleFonts.poppins(
          fontSize: 14,
          color: widget.color,
          fontWeight: FontWeight.w400),
    );
  }
}

class BigTitle extends StatefulWidget {
  BigTitle({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  State<BigTitle> createState() => _BigTitleState();
}

class _BigTitleState extends State<BigTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          fontSize: 24,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w600),
    );
  }
}

class MediumTitle extends StatefulWidget {
  MediumTitle({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  State<MediumTitle> createState() => _MediumTitleState();
}

class _MediumTitleState extends State<MediumTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          fontSize: 20,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w500),
    );
  }
}
