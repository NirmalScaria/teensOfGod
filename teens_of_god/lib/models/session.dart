import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  Session(
      {isLoaded,
      sessionId,
      attendedCount,
      classId,
      date,
      noOfStudents,
      volunteersId,
      className,
      city});
  bool isLoaded = false;
  String? sessionId;
  int? attendedCount;
  String? classId;
  DateTime? date;
  int? noOfStudents;
  List? volunteersId;
  String? className;
  String? topic;
  String? city;
  Future<bool> loadData(String sessionId) async {
    CollectionReference sessionCollection =
        FirebaseFirestore.instance.collection('Session');
    await sessionCollection.doc(sessionId).get().then((value) {
      this.sessionId = sessionId;
      attendedCount = value.get('attendedCount');
      classId = value.get('classId');
      date = (value.get('date') as Timestamp).toDate();
      noOfStudents = value.get('noOfStudents');
      volunteersId = value.get('volunteers');
      className = value.get('class');
      topic = value.get('topic');
      city = value.get('city');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }
}
