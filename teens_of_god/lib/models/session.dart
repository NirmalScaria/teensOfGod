import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:uuid/uuid.dart';

class Session {
  Session({
    this.attendedCount,
    this.city,
    this.topic,
    this.className,
    this.classId,
    this.sessionId,
    this.noOfStudents,
    this.volunteersId,
    this.date,
  });
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

  Future<String> saveToDatabase(Mentor mentor) async {
    CollectionReference sessionCollection =
        FirebaseFirestore.instance.collection('Session');
    String newUid = const Uuid().v4();
    sessionId = newUid;
    print("attended count : $attendedCount");
    sessionCollection.doc(newUid).set({
      'attendedCount': attendedCount,
      'classId': classId,
      'date': date,
      'noOfStudents': noOfStudents,
      'volunteers': volunteersId,
      'class': className,
      'topic': topic,
      'city': city,
      'sessionId': newUid,
    });
    await mentor.appendSession(newUid, date ?? DateTime.now());
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('Student');
    QuerySnapshot studentQuery =
        await studentCollection.where('classId', isEqualTo: classId).get();
    for (var student in studentQuery.docs) {
      await student.reference.update({
        'sessions': FieldValue.arrayUnion([
          {
            'date': date,
            'present': false,
            'sessionId': sessionId,
          }
        ])
      });
    }
    return (newUid);
  }
}
