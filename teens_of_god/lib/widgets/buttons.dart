import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatefulWidget {
  PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.isLoading = false})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  bool isLoading = false;
  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      radius: 4,
                      colors: <Color>[
                        Color(0xffFFDE6A),
                        Color(0xffF0D263),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  // padding: const EdgeInsets.all(6.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: widget.onPressed,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.text,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000))),
                    if (widget.isLoading) const SizedBox(width: 10),
                    if (widget.isLoading)
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xff000000),
                          ))
                  ],
                )),
              ),
            ],
          ),
        ));
  }
}

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      radius: 4,
                      colors: <Color>[
                        Color(0xffDBDBDB),
                        Color(0xffDBDBDB),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  // padding: const EdgeInsets.all(6.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: widget.onPressed,
                child: Center(
                    child: Text(widget.text,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000)))),
              ),
            ],
          ),
        ));
  }
}
