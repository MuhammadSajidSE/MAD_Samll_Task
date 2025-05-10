import 'package:firebase_database/firebase_database.dart';

class TaskController {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child("Student");

  Future<List<Map<String, dynamic>>> getTasks(
      String email, String subject) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks');

    final snapshot = await taskRef.get();
    if (!snapshot.exists) return [];

    final data = <Map<String, dynamic>>[];
    snapshot.children.forEach((child) {
      final task = child.value as Map<dynamic, dynamic>;
      data.add({
        'id': child.key,
        'title': task['title'],
        'dueDate': task['dueDate'],
        'isCompleted': task['isCompleted'] ?? false,
      });
    });

    return data;
  }

  Future<void> addTask(
      String email, String subject, String title, DateTime dueDate) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks');

    await taskRef.push().set({
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': false,
    });
  }

  Future<void> deleteTask(String email, String subject, String taskId) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks')
        .child(taskId);

    await taskRef.remove();
  }

  Future<void> markTaskComplete(
      String email, String subject, String taskId) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks')
        .child(taskId);

    await taskRef.update({'isCompleted': true});
  }

  String sanitizeEmail(String email) {
    return email.replaceAll('.', '_');
  }

  Future<void> updateTaskDueDate(
      String email, String subject, String taskId, DateTime newDate) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks')
        .child(taskId);

    await taskRef.update({'dueDate': newDate.toIso8601String()});
  }

  Future<void> toggleTaskCompletion(
      String email, String subject, String taskId) async {
    final normalizedEmail = email.replaceAll('.', '_');
    final taskRef = dbRef
        .child(normalizedEmail)
        .child('subjects')
        .child(subject)
        .child('tasks')
        .child(taskId);

    final snapshot = await taskRef.get();

    if (snapshot.exists) {
      final currentStatus =
          snapshot.child('isCompleted').value as bool? ?? false;
      await taskRef.update({'isCompleted': !currentStatus});
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllTasks(String email) async {
      final DatabaseReference _db = FirebaseDatabase.instance.ref();
    final sanitizedEmail = sanitizeEmail(email);
    final List<Map<String, dynamic>> allTasks = [];

    final userSubjectsRef = _db.child('Student').child(sanitizedEmail).child('subjects');
    final subjectsSnapshot = await userSubjectsRef.get();

    if (subjectsSnapshot.exists) {
      final subjectsData = subjectsSnapshot.value as Map<dynamic, dynamic>;

      subjectsData.forEach((subjectName, subjectData) {
        if (subjectData is Map && subjectData['tasks'] is Map) {
          final tasks = subjectData['tasks'] as Map<dynamic, dynamic>;

          tasks.forEach((taskId, taskData) {
            allTasks.add({
              'subject': subjectName,
              'title': taskData['title'] ?? '',
              'dueDate': taskData['dueDate'] ?? '',
            });
          });
        }
      });
    }

    return allTasks;
  }
}
