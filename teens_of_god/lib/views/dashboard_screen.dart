import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/views/choose_id_screen.dart';
import 'package:teens_of_god/views/forms/create_session_screen.dart';
import 'package:teens_of_god/views/forms/enroll_student.dart';
import 'package:teens_of_god/views/forms/enroll_volunteer.dart';
import 'package:teens_of_god/views/forms/select_session.dart';
import 'package:teens_of_god/views/widgets/dashboard_statistics.dart';
import 'package:teens_of_god/views/widgets/session_preview.dart';
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
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => CreateSession(mentor: mentor),
                  ),
                )
                    .then((value) {
                  setState(() {
                    loadData();
                  });
                });
              },
              text: "Create new session",
              padding: 20,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => SelectSession(mentor: mentor),
                  ),
                )
                    .then((value) {
                  setState(() {
                    loadData();
                  });
                });
              },
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
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EnrollStudent(mentor: mentor),
                  ),
                )
                    .then((value) {
                  loadData();
                });
              },
              text: "Enroll New Student",
              padding: 20,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EnrollVolunteer(mentor: mentor),
                  ),
                )
                    .then((value) {
                  loadData();
                });
              },
              text: "Enroll New Volunteer",
              padding: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => ChooseIdScreen(mentor: mentor),
                  ),
                )
                    .then((value) {
                  loadData();
                });
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xffBDC9EA),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset("lib/assets/print.png",
                            fit: BoxFit.fitWidth),
                      ),
                      const SizedBox(width: 20),
                      Text("Generate\nId Cards",
                          textAlign: TextAlign.end,
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff333333))),
                    ],
                  )),
            )
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
                    // sort sessionIds based on date in descending order
                    widget.mentor.sessionIds!.sort((a, b) {
                      return a['date']!.compareTo(b['date']);
                    });
                    for (var i = 0; i < mentor.sessionIds!.length; i++) {
                      if ((mentor.sessionIds![i]["date"] as Timestamp)
                          .toDate()
                          .isAfter(DateTime.now())) {
                        if (upcomingSessionIds.length < 2) {
                          upcomingSessionIds.add(mentor.sessionIds![i]["id"]);
                        }
                      } else {}
                    }
                    // reverse sessionIds
                    mentor.sessionIds = mentor.sessionIds!.reversed.toList();
                    for (var i = 0; i < mentor.sessionIds!.length; i++) {
                      if ((mentor.sessionIds![i]["date"] as Timestamp)
                          .toDate()
                          .isAfter(DateTime.now())) {
                      } else {
                        if (pastSessionIds.length < 2) {
                          pastSessionIds.add(mentor.sessionIds![i]["id"]);
                        }
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
                        return new SessionPreview(
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



int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
