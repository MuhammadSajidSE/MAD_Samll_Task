import 'package:flutter/material.dart';
import 'package:studenttodo/Controllers/LoginServices.dart';
import 'package:studenttodo/Views/AllSubject.dart';
import 'package:studenttodo/Views/SignUp.dart';
class studentlogin extends StatefulWidget {
  const studentlogin({super.key});

  @override
  State<studentlogin> createState() => _studentloginState();
}

class _studentloginState extends State<studentlogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";
  bool _obscurePassword = true;

  void loginStudent() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    String? result = await loginStudentService(email, password);
    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Allsubject(stduentemail: email),
        ),
      );
    } else {
      setState(() {
        errorMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter Your Email",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: loginStudent,
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(errorMessage, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const studentregistertion()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
