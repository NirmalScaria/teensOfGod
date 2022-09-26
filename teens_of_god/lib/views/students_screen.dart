import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/views/student_id_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class StudentsScreen extends StatefulWidget {
  StudentsScreen({Key? key, required this.mentor}) : super(key: key);
  Mentor mentor;
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xffD3B33B),
          elevation: 0,
          title: Text(
            "Students",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return StudentItem(
                  name: widget.mentor.students![index]['name'],
                  studentId: widget.mentor.students![index]['studentId'],
                  generatedUid: widget.mentor.students![index]['generatedUid']);
            },
            itemCount: widget.mentor.students!.length,
          ),
        ));
  }
}

class StudentItem extends StatefulWidget {
  StudentItem({
    Key? key,
    required this.name,
    required this.studentId,
    required this.generatedUid,
  }) : super(key: key);
  String name;
  String studentId;
  String generatedUid;
  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 190, 185),
                borderRadius: BorderRadius.circular(1000)),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.person_rounded),
          ),
          // randomAvatar(widget.name, height: 40, width: 40),
          Container(
            height: 40,
            width: 1,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 183, 183, 183)),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    Text(
                      widget.studentId,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    createPdf(widget.generatedUid);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => StudentIdScreen(
                    //           generatedUid: widget.generatedUid,
                    //         )));
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 183, 183, 183),
                              ),
                              Text("Id Card"),
                            ],
                          ))),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  

  void createPdf(String generatedUid) async {
    Student student = Student();
    await student.loadData(generatedUid);
    
  }
}
