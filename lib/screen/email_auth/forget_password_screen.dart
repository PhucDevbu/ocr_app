import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Forget Password"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: const BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text.trim();
                      if (email.isEmpty || !email.contains('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email address'),
                          ),
                        );
                      } else {
                        resetPassword(email);
                        Fluttertoast.showToast(msg: 'Please check your email');
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Forget Password".toUpperCase(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
