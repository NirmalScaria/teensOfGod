import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/mentor.dart';

class DashboardStatistics extends StatefulWidget {
  DashboardStatistics({Key? key, required this.mentor}) : super(key: key);
  Mentor mentor;
  @override
  State<DashboardStatistics> createState() => _DashboardStatisticsState();
}

class _DashboardStatisticsState extends State<DashboardStatistics> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffDFB0AD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 15),
                  child: Image.asset(
                    "lib/assets/student.png",
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "Students you\nonboarded",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              (widget.mentor.studentsOnboarded ?? 0)
                                      .toString() +
                                  " ",
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffADDFDC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 15),
                  child: Image.asset(
                    "lib/assets/volunteer.png",
                    height: 100,
                    width: 120,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "Volunteers you\nonboarded",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              (widget.mentor.volunteersOnboarded ?? 0)
                                      .toString() +
                                  " ",
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
