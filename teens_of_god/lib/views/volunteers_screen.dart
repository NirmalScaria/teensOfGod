import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:http/http.dart' as http;

import '../models/volunteer.dart';

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
                    createPdf(widget.generatedUid);
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var httpClient = HttpClient();
          Future<File> _downloadFile(String url, String filename) async {
            var request = await httpClient.getUrl(Uri.parse(url));
            var response = await request.close();
            var bytes = await consolidateHttpClientResponseBytes(response);
            String dir = (await getApplicationDocumentsDirectory()).path;
            File file = File('$dir/$filename');
            await file.writeAsBytes(bytes);
            return file;
          }

          Volunteer volunteer = Volunteer();

          volunteer.loadData(generatedUid).then(
            (value) {
              final queryParameters = {"output": "url"};
              var uri = Uri.https("us1.pdfgeneratorapi.com",
                  "/api/v3/templates/481400/output", queryParameters);
              http.post(uri, headers: {
                "X-Auth-Key":
                    "e411fe123ad33a09771cf5013f7a0fd37ce1db2db944f2fa022520bddeb446f4",
                "X-Auth-Secret":
                    "b1cc132460cb7a8108b33768b038ac1f9352cfed4559f31d403729da483bcd8a",
                "X-Auth-Workspace": "alreadynirmalised@gmail.com"
              }, body: '''{
                  "name": "${volunteer.name}",
                  "class": "${volunteer.location}",
                  "studentId": "${volunteer.volunteerId}",
                  "qrValue" : "${volunteer.generatedUid}"
                }''').then((response) {
                var json = jsonDecode(response.body);
                String url = (json['response']);
                _downloadFile(url, "idCard.pdf").then((pdfFile) {
                  Navigator.of(context).pop();
                  OpenFile.open(pdfFile.path);
                });
              });
            },
          );

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text(
                  "Generating the ID!\nPlease Wait.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ],
            ),
          );
        });
  }
}
