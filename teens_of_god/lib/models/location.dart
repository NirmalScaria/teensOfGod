import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/session.dart';

class Location {
  // ClassItem({
  //   isLoaded,
  //   generatedUid,
  //   mentorId,
  //   name,
  //   email,
  //   createdTimeStamp,
  //   city,
  //   sessionIds,
  //   studentsOnboarded,
  //   volunteersOnboarded,
  // });
  bool isLoaded = false;
  String? name;
  List? sessions;
  Location({
  this.name,
  this.sessions,
  });
  Future<bool> loadData(String uid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Class');
    await mentorCollection.doc(uid).get().then((value) {
      name = value.get('name');
      sessions = value.get('sessions');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json["name"],
      sessions: json["sessions"],
    );
  }
}
