import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/classItem.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class EnrollStudent extends StatefulWidget {
  EnrollStudent({Key? key, required Mentor this.mentor,}) : super(key: key);

  final Mentor mentor;

  @override
  State<EnrollStudent> createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  Map<String, ClassItem> classes = {};
  bool isLoaded = false;
  bool isSubmitting = false;
  String errorMessage = "";
  List<DropdownMenuItem> dropDownItems = [
    const DropdownMenuItem(
      child: Text("Select Class *"),
      value: "Select Class *",
    ),
  ];
  String selectedClass = "Select Class *";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    loadClasses();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xffD3B33B),
            elevation: 0,
            title: Text("Enroll New Student",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.white))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Description(
                  text:
                      "Please enter the basic information of the student. Fields marked with * are mandatory.",
                  align: TextAlign.start,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                    label: "Name *", controller: nameController, padding: 20),
                SizedBox(height: 20),
                TextInput(
                    label: "Email Address",
                    controller: emailController,
                    padding: 20),
                SizedBox(height: 10),
                Description(
                  text:
                      "Phone number is highly recommended. Further direct communication to student will be done through it.",
                  align: TextAlign.start,
                ),
                SizedBox(height: 10),
                TextInput(
                    label: "Phone", controller: phoneController, padding: 20),
                    SizedBox(height: 10),
                Description(
                  text:
                      "Student Id will be automatically generated upon registration.",
                  align: TextAlign.start,
                ),
                SizedBox(height: 10),
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
                } else if (nameController.text == "") {
                  setState(() {
                    errorMessage = "Please enter the student's name";
                  });
                } else {
                  setState(() {
                    errorMessage = "";
                    isSubmitting = true;
                  });
                  Student newStudent = Student(
                    name: nameController.text,
                    email: emailController.text,
                    mobile: phoneController.text,
                    classId: classes[selectedClass]!.classId,
                    className: classes[selectedClass]!.className,
                    location: classes[selectedClass]!.location,
                    createdTimeStamp: Timestamp.now(),
                    sessions: [],
                  );

                  String newStudentId = await newStudent.saveToDatabase(widget.mentor);

                  setState(() {
                    isSubmitting = false;
                  });
                  // show alert dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content:  Text(
                              "Student has been successfully enrolled. The Student Id is " + (newStudentId)),
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
              
              text: "Enroll Student",
              padding: 20,
            ),
              ],
            ),
          ),
        ));
  }
}
