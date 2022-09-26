import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/session.dart';

class ClassItem {
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
  String? classId;
  String? className;
  String? location;
  Timestamp? createdTimeStamp;
  int? noOfStudents;
  ClassItem({
    this.classId,
    this.className,
    this.location,
    this.createdTimeStamp,
    this.noOfStudents,
  });
  Future<bool> loadData(String uid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Class');
    await mentorCollection.doc(uid).get().then((value) {
      this.classId = uid;
      className = value.get('className');
      location = value.get('location');
      createdTimeStamp = value.get('createdTimeStamp');
      noOfStudents = value.get('noOfStudents');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      classId: json["classId"],
      className: json["className"],
      location: json["location"],
      createdTimeStamp: json["createdTimeStamp"],
      noOfStudents: json["noOfStudents"],
    );
  }
}
