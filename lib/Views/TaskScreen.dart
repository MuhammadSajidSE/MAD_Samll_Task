import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenttodo/Controllers/TaskController.dart';

class TaskScreen extends StatefulWidget {
  final String studentEmail;
  final String subjectName;

  const TaskScreen(
      {super.key, required this.studentEmail, required this.subjectName});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskController _controller = TaskController();
  List<Map<String, dynamic>> _tasks = [];
  String _error = "";
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data =
        await _controller.getTasks(widget.studentEmail, widget.subjectName);
    setState(() {
      _tasks = data;
    });
  }

  void _showAddTaskDialog() {
    String taskName = '';
    DateTime? selectedDate;
    String dialogError = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? 'Select Due Date'
                        : 'Due: ${DateFormat.yMMMd().format(selectedDate!)}',
                  ),
                ),
                if (dialogError.isNotEmpty)
                  Text(dialogError, style: const TextStyle(color: Colors.red)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (taskName.isEmpty || selectedDate == null) {
                    setState(() => dialogError = "All fields are required");
                    return;
                  }

                  await _controller.addTask(widget.studentEmail,
                      widget.subjectName, taskName, selectedDate!);
                  Navigator.pop(context);
                  _loadTasks();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    await _controller.deleteTask(
        widget.studentEmail, widget.subjectName, taskId);
    _loadTasks();
  }

  Future<void> _toggleCompleteTask(String taskId) async {
    await _controller.toggleTaskCompletion(
        widget.studentEmail, widget.subjectName, taskId);
    await _loadTasks();
  }

  void _editTaskDate(String taskId, DateTime currentDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      await _controller.updateTaskDueDate(
          widget.studentEmail, widget.subjectName, taskId, picked);
      await _loadTasks();
    }
  }

  Future<List<Map<String, dynamic>>> getTasksByDate(
      String email, String subject, DateTime selectedDate) async {
    final allTasks = await _controller.getTasks(email, subject);
    return allTasks.where((task) {
      final dueDate = DateTime.parse(task['dueDate']);
      return dueDate.year == selectedDate.year &&
          dueDate.month == selectedDate.month &&
          dueDate.day == selectedDate.day;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredTasks {
    if (_filterDate == null) return _tasks;
    return _tasks.where((task) {
      final dueDate = DateTime.parse(task['dueDate']);
      return dueDate.year == _filterDate!.year &&
          dueDate.month == _filterDate!.month &&
          dueDate.day == _filterDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subjectName} Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.blue),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _filterDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _filterDate = picked);
                    }
                  },
                ),
              ],
            ),
            if (_filterDate != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filtered by: ${DateFormat.yMMMd().format(_filterDate!)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _filterDate = null),
                    child: const Text("Clear Filter"),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredTasks.isEmpty
                  ? const Center(child: Text('No tasks found.'))
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        final isCompleted = task['isCompleted'] == true;

                        return Card(
                          color: isCompleted ? Colors.grey[300] : Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Due Date: ${DateFormat.yMMMd().format(DateTime.parse(task['dueDate']))}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.orange),
                                      onPressed: isCompleted
                                          ? null
                                          : () => _editTaskDate(
                                                task['id'],
                                                DateTime.parse(task['dueDate']),
                                              ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isCompleted
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: Colors.green,
                                      ),
                                      onPressed: () =>
                                          _toggleCompleteTask(task['id']),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _deleteTask(task['id']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
