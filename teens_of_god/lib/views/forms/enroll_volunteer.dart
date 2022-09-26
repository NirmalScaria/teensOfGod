import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teens_of_god/models/classItem.dart';
import 'package:teens_of_god/models/location.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/models/volunteer.dart';
import 'package:teens_of_god/widgets/buttons.dart';
import 'package:teens_of_god/widgets/inputs.dart';
import 'package:teens_of_god/widgets/texts.dart';

class EnrollVolunteer extends StatefulWidget {
  EnrollVolunteer({
    Key? key,
    required Mentor this.mentor,
  }) : super(key: key);

  final Mentor mentor;

  @override
  State<EnrollVolunteer> createState() => _EnrollVolunteerState();
}

class _EnrollVolunteerState extends State<EnrollVolunteer> {
  Map<String, Location> locations = {};
  bool isLoaded = false;
  bool isSubmitting = false;
  String errorMessage = "";
  List<DropdownMenuItem> dropDownItems = [
    const DropdownMenuItem(
      child: Text("Select Location *"),
      value: "Select Location *",
    ),
  ];
  String selectedLocation = "Select Location *";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    loadLocations();
    super.initState();
  }

  Future<void> loadLocations() async {
    CollectionReference locationCollection =
        FirebaseFirestore.instance.collection('Location');
    await locationCollection.get().then((value) {
      for (var element in value.docs) {
        var data = element.data() as Map;
        Location newLocation = Location(
          name: data['name'],
          sessions: data['sessions'],
        );
        locations[newLocation.name!] = newLocation;
        dropDownItems.add(
          DropdownMenuItem(
            child: Text(newLocation.name!),
            value: newLocation.name,
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
            title: Text("Enroll New Volunteer",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.white))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Description(
                  text:
                      "Please enter the basic information of the volunteer. Fields marked with * are mandatory.",
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
                      value: selectedLocation,
                      items: dropDownItems,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedLocation = value;
                          print("Setting class");
                          print(selectedLocation);
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
                      "Phone number is highly recommended. Further direct communication to volunteer will be done through it.",
                  align: TextAlign.start,
                ),
                SizedBox(height: 10),
                TextInput(
                    label: "Phone", controller: phoneController, padding: 20),
                SizedBox(height: 10),
                Description(
                  text:
                      "Volunteer Id will be automatically generated upon registration.",
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
                    if (selectedLocation == "Select Location *") {
                      setState(() {
                        errorMessage = "Please select a location";
                      });
                    } else if (nameController.text == "") {
                      setState(() {
                        errorMessage = "Please enter the volunteer's name";
                      });
                    } else {
                      setState(() {
                        errorMessage = "";
                        isSubmitting = true;
                      });
                      Volunteer newVolunteer = Volunteer(
                        name: nameController.text,
                        email: emailController.text,
                        mobile: phoneController.text,
                        location: selectedLocation,
                        createdTimeStamp: Timestamp.now(),
                        sessions: [],
                      );

                      String newVolunteerId =
                          await newVolunteer.saveToDatabase(widget.mentor);

                      setState(() {
                        isSubmitting = false;
                      });
                      // show alert dialog
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success"),
                              content: Text(
                                  "Volunteer has been successfully enrolled. The Volunteer Id is " +
                                      (newVolunteerId)),
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
                  text: "Enroll Volunteer",
                  padding: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
