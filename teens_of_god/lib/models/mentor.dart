import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/session.dart';
import 'package:teens_of_god/models/student.dart';
import 'package:teens_of_god/models/volunteer.dart';

class Mentor {
  Mentor({
    isLoaded,
    generatedUid,
    mentorId,
    name,
    email,
    createdTimeStamp,
    city,
    sessionIds,
    studentsOnboarded,
    volunteersOnboarded,
  });
  bool isLoaded = false;
  String? uid;
  String? mentorId;
  String? name;
  String? firstName;
  String? email;
  Timestamp? createdTimeStamp;
  String? city;
  String? mobile;
  List? sessionIds;
  int? studentsOnboarded;
  int? volunteersOnboarded;
  Future<bool> loadData(String uid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Mentor');
    await mentorCollection.doc(uid).get().then((value) {
      this.uid = uid;
      mentorId = value.get('mentorId');
      name = value.get('name');
      firstName = name!.split(" ")[0];
      email = value.get('email');
      createdTimeStamp = value.get('createdTimeStamp');
      city = value.get('city');
      mobile = value.get('mobile');
      sessionIds = value.get('sessions');
      studentsOnboarded = value.get('studentsOnboarded');
      volunteersOnboarded = value.get('volunteersOnboarded');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  Future<bool> addStudent(Student newStudent) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Mentor');
    await mentorCollection.doc(uid).update({
      'studentsOnboarded': FieldValue.increment(1),
      'students': FieldValue.arrayUnion([{
        'studentId': newStudent.studentId,
        'name': newStudent.name,
        'generatedUid': newStudent.generatedUid,
      }])
    });
    return (true);
  }
  Future<bool> addVolunteer(Volunteer newVolunteer) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Mentor');
    await mentorCollection.doc(uid).update({
      'volunteersOnboarded': FieldValue.increment(1),
      'volunteers': FieldValue.arrayUnion([{
        'volunteerId': newVolunteer.volunteerId,
        'name': newVolunteer.name,
        'generatedUid': newVolunteer.generatedUid,
      }])
    });
    return (true);
  }
}
