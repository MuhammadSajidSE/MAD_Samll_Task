import 'package:flutter/material.dart';
import 'package:studenttodo/Controllers/SubjectController.dart';
import 'package:studenttodo/Views/TaskScreen.dart';

class Allsubject extends StatefulWidget {
  final String stduentemail;

  const Allsubject({super.key, required this.stduentemail});

  @override
  State<Allsubject> createState() => _AllsubjectState();
}

class _AllsubjectState extends State<Allsubject> {
  final SubjectController _controller = SubjectController();
  List<String> _subjects = [];
  String _error = "";

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    List<String> result = await _controller.fetchSubjects(widget.stduentemail);
    setState(() {
      _subjects = result;
    });
  }

  Future<void> _addSubject(String subject) async {
    if (subject.isEmpty) return;

    String? result = await _controller.addSubject(widget.stduentemail, subject);

    if (result != null) {
      // Show error in a popup dialog
      _showErrorDialog(result);
    } else {
      setState(() {
        _error = "";
      });
      await _loadSubjects();
    }
  }

// Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSubject(String subject) async {
    await _controller.deleteSubject(widget.stduentemail, subject);
    await _loadSubjects();
  }

  Future<void> _showAddSubjectDialog() async {
    final TextEditingController subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Subject"),
        content: TextField(
          controller: subjectController,
          decoration: const InputDecoration(hintText: 'Enter subject name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog without adding
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addSubject(subjectController.text.trim());
              Navigator.pop(context); // Close dialog after adding
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                16, 16, 16, 70), // Leave space at bottom
            child: Column(
              children: [
                if (_error.isNotEmpty)
                  Text(_error, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _subjects.length,
                    itemBuilder: (context, index) {
                      final subject = _subjects[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskScreen(
                                studentEmail: widget.stduentemail,
                                subjectName: subject,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.blue.shade50,
                          elevation: 5,
                          child: ListTile(
                            title: Text(subject,
                                style: const TextStyle(fontSize: 18)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSubject(subject),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Sticky button at the bottom

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Subject',
      ),
    );
  }
}

//sajid