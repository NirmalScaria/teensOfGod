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
  String? locationId;
  Location({
  this.name,
  this.sessions,
  this.locationId,
  });
  Future<bool> loadData(String uid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Class');
    await mentorCollection.doc(uid).get().then((value) {
      name = value.get('name');
      sessions = value.get('sessions');
      locationId = value.get('locationId');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json["name"],
      locationId: json["locationid"],
      sessions: json["sessions"],
    );
  }

  Future<bool> appendSession(String id, DateTime date,) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Mentor');
        Timestamp timestamp = Timestamp.fromDate(date);
    await mentorCollection.doc(locationId).update({
      'sessions': FieldValue.arrayUnion([{
        'id': id,
        'date': timestamp
      }])
    });
    return (true);
  }
}
