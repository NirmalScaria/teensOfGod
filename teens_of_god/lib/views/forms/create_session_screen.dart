import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/classItem.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/models/volunteer.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';
import 'package:intl/intl.dart';

class CreateSession extends StatefulWidget {
  CreateSession({
    Key? key,
    required Mentor this.mentor,
  }) : super(key: key);

  final Mentor mentor;

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  Map<String, ClassItem> classes = {};
  Map<String, Volunteer> volunteers = {};
  Set<String> selectedVolunteerIds = {};
  bool isLoaded = false;
  bool isSubmitting = false;
  String errorMessage = "";
  String selectedTimeString = "Select time and date *";
  List<DropdownMenuItem> dropDownItems = [
    const DropdownMenuItem(
      child: Text("Select Class *"),
      value: "Select Class *",
    ),
  ];
  String selectedClass = "Select Class *";
  TextEditingController subjectController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Volunteer> selectedVolunteers = [];

  @override
  void initState() {
    loadClasses();
    loadVolunteers();
    super.initState();
  }

  Future<void> loadClasses() async {
    CollectionReference classCollection =
        FirebaseFirestore.instance.collection('Class');
    await classCollection.get().then((value) {
      for (var element in value.docs) {
        var data = element.data() as Map;
        ClassItem newClass = ClassItem(
          classId: element.id,
          className: data['className'],
          location: data['location'],
          createdTimeStamp: data['createdTimeStamp'],
          noOfStudents: data['noOfStudents'],
        );
        classes[newClass.className!] = newClass;
        dropDownItems.add(
          DropdownMenuItem(
            child: Text(newClass.className!),
            value: newClass.className,
          ),
        );
      }
    });
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> loadVolunteers() async {
    CollectionReference classCollection =
        FirebaseFirestore.instance.collection('Volunteer');
    await classCollection.get().then((value) {
      for (var element in value.docs) {
        var data = element.data() as Map;
        Volunteer newVolunteer = Volunteer(
          name: data['name'],
          generatedUid: data['generatedUid'],
          location: data['location'],
          createdTimeStamp: data['createdTimeStamp'],
          volunteerId: data['volunteerId'],
        );
        volunteers[newVolunteer.volunteerId!] = newVolunteer;
      }
    });
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xffD3B33B),
            elevation: 0,
            title: Text("Create new Session",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.white))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Description(
                  text:
                      "This will create a new class session/lecture for the class you select.",
                  align: TextAlign.start,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      elevation: 1,
                      isExpanded: true,
                      value: selectedClass,
                      items: dropDownItems,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedClass = value;
                          print("Setting class");
                          print(selectedClass);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextInput(
                    label: "Subject / Title *",
                    controller: subjectController,
                    padding: 20),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      selectedDate = date;
                      setState(() {
                        DateFormat dateFormat =
                            DateFormat("hh:mm a, dd MMMM yyyy ");
                        selectedTimeString = dateFormat.format(selectedDate);
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButtonHideUnderline(
                      child: IgnorePointer(
                        child: DropdownButton(
                          elevation: 1,
                          isExpanded: true,
                          value: selectedTimeString,
                          items: [
                            DropdownMenuItem(
                              child: Text(selectedTimeString),
                              value: selectedTimeString,
                            ),
                          ],
                          onChanged: (dynamic value) {},
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [MediumTitle(text: "Select Volunteers"), Spacer()],
                ),
                Description(
                  text:
                      "Select the volunteers who are suppose to participate in this session.",
                  align: TextAlign.start,
                ),
                SizedBox(height: 10),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: volunteers.length,
                    itemBuilder: (context, index) {
                      Volunteer volunteer = volunteers.values.elementAt(index);
                      return CheckboxListTile(
                        title: Text(volunteer.name!),
                        value: selectedVolunteerIds
                            .contains(volunteer.volunteerId),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedVolunteerIds.add(volunteer.volunteerId!);
                            } else {
                              selectedVolunteerIds
                                  .remove(volunteer.volunteerId!);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                errorMessage != ""
                    ? Description(
                        text: errorMessage,
                        align: TextAlign.start,
                        color: Colors.red,
                      )
                    : Container(),
                PrimaryButton(
                  isLoading: isSubmitting,
                  onPressed: () async {
                    if (selectedClass == "Select Class *") {
                      setState(() {
                        errorMessage = "Please select a class";
                      });
                    } else if (subjectController.text == "") {
                      setState(() {
                        errorMessage = "Please enter the subject / title";
                      });
                    } else if (selectedTimeString == "Select time and date *") {
                      setState(() {
                        errorMessage = "Please choose the date and time!";
                      });
                    } else {
                      setState(() {
                        errorMessage = "";
                        isSubmitting = true;
                      });
                      Session newSession = Session(
                        attendedCount: 0,
                        classId: classes[selectedClass]!.classId,
                        className: classes[selectedClass]!.className,
                        date: selectedDate,
                        city: classes[selectedClass]!.location,
                        noOfStudents: classes[selectedClass]!.noOfStudents,
                        topic: subjectController.text,
                        volunteersId: selectedVolunteerIds.toList(),
                      );

                      String newStudentId =
                          await newSession.saveToDatabase(widget.mentor);

                      setState(() {
                        isSubmitting = false;
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success"),
                              content: Text(
                                  "The session has been successfully created!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    }
                  },
                  text: "Create Session",
                  padding: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
