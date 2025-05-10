import 'package:firebase_database/firebase_database.dart';

class SubjectController {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Student');

  String _sanitizeEmail(String email) => email.replaceAll('.', '_');

  Future<List<String>> fetchSubjects(String email) async {
    final emailKey = _sanitizeEmail(email);
    final snapshot = await _dbRef.child(emailKey).child('subjects').get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.keys.cast<String>().toList();
    }
    return [];
  }

  Future<String?> addSubject(String email, String subject) async {
    final emailKey = _sanitizeEmail(email);
    final subjectRef = _dbRef.child(emailKey).child('subjects').child(subject);

    final snapshot = await subjectRef.get();
    if (snapshot.exists) {
      return 'Subject already exists.';
    }

    await subjectRef.set(true);
    return null;
  }

  Future<void> deleteSubject(String email, String subject) async {
    final emailKey = _sanitizeEmail(email);
    await _dbRef.child(emailKey).child('subjects').child(subject).remove();
  }
}
