import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextC = true;
  void createAccount() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        cPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all details.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    } else if (password != cPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          UserApp user =
              UserApp(email: email, name: name, uId: userCredential.user!.uid);
          FirebaseFirestore.instance.collection("users").add(user.toMap());
          Fluttertoast.showToast(msg: 'Sign Up Success');
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (ex) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ex.code.toString()),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create an account"),
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person),
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
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // toggle password visibility
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          semanticLabel:
                              _obscureText ? 'show password' : 'hide password',
                        ),
                      ),
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
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: _obscureTextC,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // toggle password visibility
                          setState(() {
                            _obscureTextC = !_obscureTextC;
                          });
                        },
                        child: Icon(
                          _obscureTextC
                              ? Icons.visibility_off
                              : Icons.visibility,
                          semanticLabel:
                              _obscureTextC ? 'show password' : 'hide password',
                        ),
                      ),
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
                    controller: cPasswordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createAccount();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "create account".toUpperCase(),
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
