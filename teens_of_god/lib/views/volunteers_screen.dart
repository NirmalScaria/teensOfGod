import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:teens_of_god/views/student_id_screen.dart';
import 'package:teens_of_god/views/volunteer_id_screen.dart';

class VolunteersScreen extends StatefulWidget {
  VolunteersScreen({Key? key, required this.mentor}) : super(key: key);
  Mentor mentor;
  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xffD3B33B),
          elevation: 0,
          title: Text(
            "Volunteers",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return VolunteerItem(
                  name: widget.mentor.volunteers![index]['name'],
                  studentId: widget.mentor.volunteers![index]['volunteerId'],
                  generatedUid: widget.mentor.volunteers![index]
                      ['generatedUid']);
            },
            itemCount: widget.mentor.volunteers!.length,
          ),
        ));
  }
}

class VolunteerItem extends StatefulWidget {
  VolunteerItem({
    Key? key,
    required this.name,
    required this.studentId,
    required this.generatedUid,
  }) : super(key: key);
  String name;
  String studentId;
  String generatedUid;
  @override
  State<VolunteerItem> createState() => _VolunteerItemState();
}

class _VolunteerItemState extends State<VolunteerItem> {
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VolunteerIdScreen(
                              generatedUid: widget.generatedUid,
                            )));
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
}
