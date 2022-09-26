import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/session.dart';

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
}
