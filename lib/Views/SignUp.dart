import 'package:flutter/material.dart';
import 'package:studenttodo/Controllers/Registation.dart';
import 'package:studenttodo/Views/AllSubject.dart';
import 'package:studenttodo/Views/login.dart';

class studentregistertion extends StatefulWidget {
  const studentregistertion({super.key});
  @override
  State<studentregistertion> createState() => _studentregistertionState();
}

class _studentregistertionState extends State<studentregistertion> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController rollNo = TextEditingController();
  final TextEditingController year = TextEditingController();
  String errorMessage = "";

  final FirebaseRegistrationService _service = FirebaseRegistrationService();

  void stdregister() async {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        department.text.isEmpty ||
        rollNo.text.isEmpty ||
        year.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill all fields";
      });
      return;
    }

    final studentData = {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'department': department.text,
      'rollNo': rollNo.text,
      'year': year.text,
    };

    String? result = await _service.registerStudent(studentData);

    if (result != null) {
      setState(() {
        errorMessage = result;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Allsubject(stduentemail: email.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(),
          Container(
            padding: const EdgeInsets.only(left: 35, top: 130),
            child: const Text(
              'Welcome\nStudent Task',
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        buildField("Enter Your Name", name),
                        const SizedBox(height: 10),
                        buildField("Enter Your Email", email),
                        const SizedBox(height: 10),
                        buildField("Enter Password", password, obscure: true),
                        const SizedBox(height: 10),
                        buildField("Your Department", department),
                        const SizedBox(height: 10),
                        buildField("Enter Your Roll No", rollNo),
                        const SizedBox(height: 10),
                        buildField("College Year", year),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w700),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: stdregister,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          child: const Text("If have an account login?"),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const studentlogin()),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
