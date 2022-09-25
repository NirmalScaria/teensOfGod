import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
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
                  padding: const EdgeInsets.all(6.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: Center(
                    child: Text(widget.text,
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ),
            ],
          ),
        ));
  }
}
