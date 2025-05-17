import 'package:flutter/material.dart';
import 'package:studenttodo/Controllers/models/course_model.dart';
import 'package:studenttodo/Views/widgets/course_card.dart';
import 'package:studenttodo/Views/widgets/dashboard_appbar.dart';

class DashboardPage extends StatelessWidget {
    final List<Course> courses;

  const DashboardPage({super.key ,  required this.courses});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5),
      appBar: const DashboardAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'My Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (ctx, i) => CourseCard(course: courses[i]),
            ),
          ),
        ],
      ),
    );
  }
}