import 'package:firebase_database/firebase_database.dart';

Future<String?> loginStudentService(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return "Please fill all fields";
  }
  String emailKey = email.replaceAll('.', '_');
  final dbRef =
      FirebaseDatabase.instance.ref().child("Student").child(emailKey);
  final snapshot = await dbRef.get();
  if (snapshot.exists) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    if (data['password'] == password) {
      return null;
    } else {
      return "Invalid password";
    }
  } else {
    return "Email not found";
  }
}
