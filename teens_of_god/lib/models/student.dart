import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:uuid/uuid.dart';

class Student {
  bool isLoaded = false;
  String? generatedUid;
  String? classId;
  String? className;
  String? name;
  String? email;
  Timestamp? createdTimeStamp;
  String? location;
  List? sessions;
  String? mobile;
  String? studentId;
  Student({
    this.generatedUid,
    this.classId,
    this.className,
    this.name,
    this.email,
    this.createdTimeStamp,
    this.location,
    this.sessions,
    this.mobile,
    this.studentId,
  });
  Future<bool> loadData(String generatedUid) async {
    CollectionReference mentorCollection =
        FirebaseFirestore.instance.collection('Student');
    await mentorCollection.doc(generatedUid).get().then((value) {
      this.generatedUid = generatedUid;
      name = value.get('name');
      email = value.get('email');
      createdTimeStamp = value.get('createdTimeStamp');
      classId = value.get('classId');
      location = value.get('location');
      sessions = value.get('sessions');
      className = value.get('className');
      mobile = value.get('mobile');
      studentId = value.get('studentId');
      isLoaded = true;
      print(value.data());
    });
    return (true);
  }

  Future<String> saveToDatabase(Mentor mentor) async {
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('Student');
    QuerySnapshot lastAdded = await studentCollection
        .orderBy('createdTimeStamp', descending: true)
        .limit(1)
        .get();
    var lastAddedData = lastAdded.docs[0].data() as Map;
    var lastStudentId = lastAddedData['studentId'];
    var lastStudentIdNumber = int.parse(lastStudentId.substring(1));
    var newStudentIdNumber = lastStudentIdNumber + 1;
    var newStudentId = 'S' + newStudentIdNumber.toString().padLeft(4, '0');
    String newUid = const Uuid().v4();
    studentId = newStudentId;
    generatedUid = newUid;
    await studentCollection.doc(newUid).set({
      'name': name,
      'studentId': newStudentId,
      'generatedUid': newUid,
      'email': email,
      'createdTimeStamp': createdTimeStamp,
      'classId': classId,
      'className': className,
      'location': location,
      'sessions': sessions,
      'mobile': mobile,
    });
    await mentor.addStudent(this);
    return (newStudentId);
  }
}
