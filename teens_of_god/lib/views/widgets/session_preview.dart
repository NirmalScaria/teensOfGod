import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:intl/intl.dart';
import 'package:teens_of_god/views/mark_attendance.dart';
class SessionPreview extends StatefulWidget {
  SessionPreview({
    Key? key,
    this.sessionId,
    required this.index,
    required this.isUpcoming,
    this.isClickable,
    this.mentor,
  }) : super(key: key);
  String? sessionId;
  int index;
  Mentor? mentor;
  bool isUpcoming;
  bool? isClickable;

  @override
  State<SessionPreview> createState() => _SessionPreviewState();
}

class _SessionPreviewState extends State<SessionPreview> {
  List<Color> colors = [
    const Color.fromARGB(255, 151, 71, 71),
    const Color.fromARGB(255, 229, 178, 102),
  ];

  @override
  void initState() {
    if (widget.sessionId != null) {
      loadData();
    }
    super.initState();
  }

  Future<void> loadData() async {
    session.loadData(widget.sessionId!).then((value) {
      setState(() {});
    });
  }

  Session session = Session();
  DateFormat dateFormat = DateFormat("hh:mm a, dd MMMM yyyy ");
  @override
  Widget build(BuildContext context) {
    if (widget.sessionId != null && widget.sessionId != session.sessionId) {
      loadData();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: GestureDetector(
        onTap: () {
          if(widget.isClickable == true && session.attendedCount!=null){
            Navigator.of(context).push(MaterialPageRoute(builder: 
            (context) => MarkAttendance(session: session, mentor: widget.mentor!)));
          }
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: colors[widget.index % 2], width: 4)),
                color: const Color(0xffF4F4F4)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Color(0xff727272),
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          session.isLoaded
                              ? Text(
                                  dateFormat.format(session.date ?? DateTime.now()),
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff727272),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12))
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 150,
                                    height: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                      session.isLoaded
                          ? Text("Session on ${session.topic ?? ""}",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12))
                          : Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 220,
                                height: 16,
                                color: Colors.grey,
                              ),
                            ),
                      Row(
                        children: [
                          Text("Class: ",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                          session.isLoaded
                              ? Text(session.className ?? "",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12))
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 70,
                                    height: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.place,
                            color: Color(0xff727272),
                            size: 16,
                          ),
                          session.isLoaded
                              ? Text(session.city ?? "",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xff727272),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12))
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 50,
                                    height: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.access_time_outlined,
                        color: Color(0xff075E00)),
                    session.isLoaded ?
                    daysBetween(DateTime.now(),
                                            session.date ?? DateTime.now()) == 0 ?
                                            Text(
                                "Today",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xff075E00),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12)) :
                        widget.isUpcoming
                            ? Text(
                                "in " +
                                    daysBetween(DateTime.now(),
                                            session.date ?? DateTime.now())
                                        .toString() +
                                    " days",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xff075E00),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12))
                            : Text(
                                daysBetween(session.date ?? DateTime.now(),
                                            DateTime.now())
                                        .toString() +
                                    " days ago",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xff075E00),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12))
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 50,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
  int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
}