import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'login_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<UserApp> getUserStream(String uid) {
      return FirebaseFirestore.instance
          .collection('users')
          .where('uId', isEqualTo: uid)
          .snapshots()
          .map((querySnapshot) =>
              UserApp.fromMap(querySnapshot.docs.first.data()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: StreamBuilder<UserApp>(
        stream: getUserStream(_user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Show OCR history
                  },
                  child: Text('OCR History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Log Out'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _auth.sendPasswordResetEmail(email: user.email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset email sent')),
                    );
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
