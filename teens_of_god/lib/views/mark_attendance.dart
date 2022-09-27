import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:teens_of_god/models/classItem.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/views/widgets/session_preview.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class MarkAttendance extends StatefulWidget {
  MarkAttendance({
    Key? key,
    required Mentor this.mentor,
    required Session this.session,
  }) : super(key: key);

  final Mentor mentor;
  final Session session;

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    Barcode? result;
    QRViewController? controller;
    @override
    void reassemble() {
      super.reassemble();
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }

    void _onQRViewCreated(QRViewController controller) {
      controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          result = scanData;
        });
      });
    }

    @override
    void dispose() {
      controller?.dispose();
      super.dispose();
    }

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
                Description(
                    text:
                        "Please scan the QR code on the Student Id card or Volunteer Id card",
                    align: TextAlign.start),

                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                // Button
                // mark attendance
                TextButton(
                    onPressed: () {
                      markAttendance(widget.session,
                          "Sb8daa80b-7a3c-4a3d-9717-b052cda1809d");
                    },
                    child: Text("Mark")),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: (result != null)
                        ? Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                        : Text('Scan a code'),
                  ),
                )
              ],
            )));
  }

  Future<void> showError(String errorMsg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMsg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> markAttendance(Session session, String scannedVal) async {
    if (scannedVal.substring(0, 1) == 'V') {
      String volunteerId = scannedVal.substring(1);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Mark Attendance"),
              content: Text("Confirm mark attendance"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      session.markVolunteerAttendance(volunteerId).then(
                        (response) {
                          Navigator.of(context).pop();
                          if (response == 'SUCCESS') {
                            // show success
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Mark Attendance"),
                                    content:
                                        Text("Attendance marked successfully"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  );
                                });
                          } else {
                            String errorMessage = "";
                            if (response == 'ALREADYMARKED') {
                              errorMessage = "Attendance already marked";
                            } else if (response == 'WRONGCLASS') {
                              errorMessage = "Student is not in this class";
                            } else {
                              errorMessage = "Unknown error";
                            }
                            showError(errorMessage);
                          }
                        },
                      );
                    },
                    child: Text("Mark"))
              ],
            );
          });
      // Volunteer foundf
    } else {
      // student found
      String studentId = scannedVal.substring(1);
      // show dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Mark Attendance"),
              content: Text("Confirm mark attendance"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      session.markAttendance(studentId).then(
                        (response) {
                          Navigator.of(context).pop();
                          if (response == 'SUCCESS') {
                            // show success
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Mark Attendance"),
                                    content:
                                        Text("Attendance marked successfully"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  );
                                });
                          } else {
                            String errorMessage = "";
                            if (response == 'ALREADYMARKED') {
                              errorMessage = "Attendance already marked";
                            } else if (response == 'WRONGCLASS') {
                              errorMessage = "Student is not in this class";
                            } else {
                              errorMessage = "Unknown error";
                            }
                            showError(errorMessage);
                          }
                        },
                      );
                    },
                    child: Text("Mark"))
              ],
            );
          });
    }
  }
}
