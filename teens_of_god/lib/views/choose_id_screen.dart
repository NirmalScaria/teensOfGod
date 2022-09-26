import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/views/students_screen.dart';
import 'package:teens_of_god/views/volunteers_screen.dart';
import 'package:teens_of_god/widgets/texts.dart';

class ChooseIdScreen extends StatefulWidget {
  ChooseIdScreen({Key? key, required this.mentor}) : super(key: key);
  Mentor mentor;
  @override
  State<ChooseIdScreen> createState() => _ChooseIdScreenState();
}

class _ChooseIdScreenState extends State<ChooseIdScreen> {
  @override
  void initState() {
    String uid = auth!.getUid();
    widget.mentor.loadData(uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xffD3B33B),
          elevation: 0,
          title: Text(
            "Generate Id Card",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please choose one\nto continue",
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudentsScreen(
                                  mentor: widget.mentor,
                                )));
                      },
                      child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xffDFB0AD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 20),
                                child: SizedBox(
                                  height: 100,
                                  child: Image.asset('lib/assets/student.png',
                                      fit: BoxFit.fitWidth),
                                ),
                              ),
                              Text("Student \nId Card",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          )),
                    )),
                    const SizedBox(width: 20),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VolunteersScreen(
                                  mentor: widget.mentor,
                                )));
                          },
                          child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xffADDFDC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 20),
                                    child: SizedBox(
                                      height: 100,
                                      child: Image.asset(
                                          'lib/assets/volunteer.png',
                                          fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                  Text("Volunteer\nId Card",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                        )),
                  ],
                ))
          ],
        ))));
  }
}
