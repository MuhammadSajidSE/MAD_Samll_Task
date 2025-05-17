import 'package:flutter/material.dart';
// import 'package:studenttodo/Controllers/Registation.dart'; // Firebase-related
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
  bool _obscurePassword = true;

  // final FirebaseRegistrationService _service = FirebaseRegistrationService(); // Firebase

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

    // Simulate successful registration instead of Firebase call
    // String? result = await _service.registerStudent(studentData); // Firebase

    String? result = null; // Simulating successful registration

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
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF9090),
                Color(0xFFFF7070),
                Color(0xFFFFD0D0),
                Color(0xFFFFB0B0),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 30),

                      buildField("Enter Your Name", name),
                      const SizedBox(height: 16),
                      buildField("Enter Your Email", email),
                      const SizedBox(height: 16),
                      buildField("Enter Password", password, obscure: true),
                      const SizedBox(height: 16),
                      buildField("Your Department", department),
                      const SizedBox(height: 16),
                      buildField("Enter Your Roll No", rollNo),
                      const SizedBox(height: 16),
                      buildField("College Year", year),
                      const SizedBox(height: 20),

                      if (errorMessage.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// Register button aligned to right
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: stdregister,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 32),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const studentlogin(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget buildField(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure ? _obscurePassword : false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
