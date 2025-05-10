// firebase_registration_service.dart
import 'package:firebase_database/firebase_database.dart';

class FirebaseRegistrationService {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Student");

  Future<bool> isEmailExists(String email) async {
    final snapshot = await dbRef.orderByChild("email").equalTo(email).once();
    return snapshot.snapshot.value != null;
  }

  Future<String?> registerStudent(Map<String, dynamic> studentData) async {
    bool exists = await isEmailExists(studentData['email']);
    if (exists) return "Email already exists";

    String emailKey = studentData['email'].replaceAll('.', '_');
    await dbRef.child(emailKey).set(studentData);
    return null;
  }
}
