import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../result_page.dart';
import 'welcome_screen.dart';

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
        title: const Text('User Profile'),
      ),
      body: StreamBuilder<UserApp>(
        stream: getUserStream(_user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  color: Colors.grey[300],
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user.email),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('OCR History'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResultScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  onTap: () {
                    _auth.sendPasswordResetEmail(email: user.email);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset email sent')));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () {
                    _auth.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
