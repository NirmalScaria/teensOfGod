import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/models/student.dart';
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

  Future<String> markAttendance(String studentGeneratedId) async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('Student');
    var value = await studentCollection.doc(studentGeneratedId).get();
    List studentsSessions = value.get('sessions') as List;
    bool isFound = false;
    bool alreadyMarked = false;
    for (int i = 0; i < studentsSessions.length; i++) {
      if (studentsSessions[i]['sessionId'] == this.sessionId) {
        isFound = true;
        if (studentsSessions[i]['present'] == true) {
          alreadyMarked = true;
        } else {
          studentsSessions[i]['present'] = true;
          CollectionReference sessionCollection =
              FirebaseFirestore.instance.collection('Session');
          await sessionCollection.doc(sessionId).update({
            'attendedCount': attendedCount! + 1,
          });
        }
      }
    }
    if (isFound == false) {
      return ("WRONGCLASS");
    } else if (alreadyMarked) {
      return ("ALREADYMARKED");
    } else {
      await studentCollection.doc(studentGeneratedId).update({
        'sessions': studentsSessions,
      });
      return ("SUCCESS");
    }
  }

  Future<String> markVolunteerAttendance(String volunteerGeneratedId) async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('Volunteer');
    var value = await studentCollection.doc(volunteerGeneratedId).get();
    List studentsSessions = value.get('sessions') as List;
    bool alreadyMarked = false;
    for (int i = 0; i < studentsSessions.length; i++) {
      if (studentsSessions[i]['sessionId'] == this.sessionId) {
        alreadyMarked = true;
          CollectionReference sessionCollection =
              FirebaseFirestore.instance.collection('Session');
          await sessionCollection.doc(sessionId).update({
            'volunteers': FieldValue.arrayUnion([volunteerGeneratedId]),
          });
      }
    }
    if (alreadyMarked) {
      return ("ALREADYMARKED");
    } else {
      // add session to volunteer
      await studentCollection.doc(volunteerGeneratedId).update({
        'sessions': FieldValue.arrayUnion([
          {
            'date': date,
            'sessionId': sessionId,
          }
        ])
      });
      // await studentCollection.doc(volunteerGeneratedId).update({
      //   'sessions': studentsSessions,
      // });
      return ("SUCCESS");
    }
  }
}
