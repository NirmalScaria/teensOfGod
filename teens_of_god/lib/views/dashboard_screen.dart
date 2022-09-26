import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/views/widgets/dashboard_statistics.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/texts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<bool> loadData() async {
    String uid = auth!.getUid();
    await mentor.loadData(uid).then(
      (value) {
        setState(() {});
      },
    );
    return (true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            BigTitle(text: "Hello " + (mentor.firstName ?? "")),
            const Divider(color: Color(0xff333333)),
            const SizedBox(height: 10),
            OverView(mentor: mentor),
            PrimaryButton(
              onPressed: () {},
              text: "Create new session",
              padding: 20,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {},
              text: "Take Attendance",
              padding: 20,
            ),
            const SizedBox(height: 20),
            MediumTitle(text: "My Statistics"),
            Description(
                text:
                    "These numbers very closely represent the amount of smiles you caused.",
                align: TextAlign.start),
            const SizedBox(height: 20),
            DashboardStatistics(mentor: mentor),
            const SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {},
              text: "Enroll New Student",
              padding: 20,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {},
              text: "Enroll New Volunteer",
              padding: 20,
            ),
          ],
        ),
      ),
    ));
  }
}

class OverView extends StatefulWidget {
  OverView({Key? key, required this.mentor}) : super(key: key);
  Mentor mentor;
  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  bool showUpcoming = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumTitle(text: "Overview"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              showUpcoming = !showUpcoming;
            });
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(4)),
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: showUpcoming
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 2 - 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      margin: const EdgeInsets.all(4)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showUpcoming = !showUpcoming;
                        });
                      },
                      child: Text(
                        "Upcoming",
                        style: TextStyle(
                            color: showUpcoming
                                ? Colors.black
                                : const Color(0xff535353),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showUpcoming = !showUpcoming;
                        });
                      },
                      child: Text(
                        "Past",
                        style: TextStyle(
                            color: showUpcoming
                                ? const Color(0xff535353)
                                : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: mentor.isLoaded == false
                ? Column(
                    children: [
                      SessionPreview(
                        index: 0,
                        isUpcoming: showUpcoming,
                      ),
                      SessionPreview(index: 1, isUpcoming: showUpcoming),
                    ],
                  )
                : Builder(builder: (context) {
                    List upcomingSessionIds = [];
                    List pastSessionIds = [];
                    for (var i = 0; i < mentor.sessionIds!.length; i++) {
                      if ((mentor.sessionIds![i]["date"] as Timestamp)
                          .toDate()
                          .isAfter(DateTime.now())) {
                        upcomingSessionIds.add(mentor.sessionIds![i]["id"]);
                      } else {
                        pastSessionIds.add(mentor.sessionIds![i]["id"]);
                      }
                    }
                    if (showUpcoming) {
                      if (upcomingSessionIds.isEmpty) {
                        return Center(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset("lib/assets/empty.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  fit: BoxFit.fitWidth),
                            ),
                            const Text("No upcoming sessions"),
                          ],
                        ));
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: upcomingSessionIds.length,
                        itemBuilder: ((context, index) {
                          return SessionPreview(
                              index: index,
                              isUpcoming: true,
                              sessionId: upcomingSessionIds[index]);
                        }),
                      );
                    }
                    if (pastSessionIds.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset("lib/assets/empty.png",
                                width: MediaQuery.of(context).size.width * 0.3,
                                fit: BoxFit.fitWidth),
                          ),
                          const Text("No past sessions"),
                        ],
                      ));
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: pastSessionIds.length,
                      itemBuilder: ((context, index) {
                        return SessionPreview(
                          index: index,
                          sessionId: pastSessionIds[index],
                          isUpcoming: false,
                        );
                      }),
                    );
                  })),
      ],
    );
  }
}

class SessionPreview extends StatefulWidget {
  SessionPreview({
    Key? key,
    this.sessionId,
    required this.index,
    required this.isUpcoming,
  }) : super(key: key);
  String? sessionId;
  int index;
  bool isUpcoming;

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
  DateFormat dateFormat = DateFormat("HH:mm a, dd MMMM yyyy ");
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
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
              Column(
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
              Column(
                children: [
                  const Icon(Icons.access_time_outlined,
                      color: Color(0xff075E00)),
                  session.isLoaded
                      ? widget.isUpcoming
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
    );
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
