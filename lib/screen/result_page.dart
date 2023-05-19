import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/result.dart';
import 'details_history.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('results')
            .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final results = snapshot.data!.docs
              .map((doc) => Result.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsHistory(
                          result: result,
                          id: documents[index].id,
                        ),
                      ),
                    ),
                    title: Text(
                      result.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Created at ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(result.createAt))}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('results')
                            .doc(documents[index].id)
                            .delete();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height:
                          0.0, // set the height to 0.0 to remove extra space
                      thickness: 3.0, // set the thickness to the desired value
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
