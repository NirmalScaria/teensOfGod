import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:uuid/uuid.dart';

class Volunteer {
  bool isLoaded = false;
  String? generatedUid;
  String? name;
  String? email;
  Timestamp? createdTimeStamp;
  String? location;
  List? sessions;
  String? mobile;
  String? volunteerId;
  Volunteer({
    this.generatedUid,
    this.name,
    this.email,
    this.createdTimeStamp,
    this.location,
    this.sessions,
    this.mobile,
    this.volunteerId,
  });
  Future<bool> loadData(String generatedUid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Student');
    await mentorCollection.doc(generatedUid).get().then((value) {
      this.generatedUid = generatedUid;
      name = value.get('name');
      email = value.get('email');
      createdTimeStamp = value.get('createdTimeStamp');
      location = value.get('location');
      sessions = value.get('sessions');
      mobile = value.get('mobile');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  Future<String> saveToDatabase(Mentor mentor) async {
    CollectionReference volunteerCollection =
        FirebaseFirestore.instance.collection('Volunteer');
    QuerySnapshot lastAdded = await volunteerCollection
        .orderBy('createdTimeStamp', descending: true)
        .limit(1)
        .get();
    var lastAddedData = lastAdded.docs[0].data() as Map;
    var lastStudentId = lastAddedData['volunteerId'];
    var lastStudentIdNumber = int.parse(lastStudentId.substring(1));
    var newStudentIdNumber = lastStudentIdNumber + 1;
    var newVolunteerId = 'V' + newStudentIdNumber.toString().padLeft(4, '0');
    String newUid = const Uuid().v4();
    generatedUid = newUid;
    volunteerId = newVolunteerId;
    await volunteerCollection.doc(newUid).set({
      'name': name,
      'volunteerId': newVolunteerId,
      'generatedUid': newUid,
      'email': email,
      'createdTimeStamp': createdTimeStamp,
      'location': location,
      'sessions': sessions,
      'mobile': mobile,
    });
    await mentor.addVolunteer(this);
    return (newVolunteerId);
  }
}
