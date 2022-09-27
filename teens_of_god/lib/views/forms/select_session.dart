import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/classItem.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/views/mark_attendance.dart';
import 'package:teens_of_god/views/widgets/session_preview.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class SelectSession extends StatefulWidget {
  SelectSession({
    Key? key,
    required Mentor this.mentor,
  }) : super(key: key);

  final Mentor mentor;

  @override
  State<SelectSession> createState() => _SelectSessionState();
}

class _SelectSessionState extends State<SelectSession> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xffD3B33B),
            elevation: 0,
            title: Text("Mark Attendance",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.white))),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [MediumTitle(text: "Please select the Session"), Spacer()],
                ),
                SizedBox(height: 20),
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.mentor.sessionIds!.length,
                  itemBuilder: (context, index) {
                    Timestamp dateStamp =
                        widget.mentor.sessionIds![index]['date'];
                    // timestamp to datetime
                    DateTime date = dateStamp.toDate();
                    return SessionPreview(
                      mentor: widget.mentor,
                      isClickable: true,
                      sessionId: widget.mentor.sessionIds![index]['id'],
                      index: index,
                      isUpcoming: date.isAfter(DateTime.now()),
                    );
                  },
                )),
              ],
            )));
  }
}
