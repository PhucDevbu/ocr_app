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
          title: const Text('Results'),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('results')
              .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            final sortedDocuments = documents.toList();
            sortedDocuments
                .sort((a, b) => b['createAt'].compareTo(a['createAt']));

            return ListView.builder(
              itemCount: sortedDocuments.length,
              itemBuilder: (context, index) {
                final result = Result.fromMap(sortedDocuments[index].data());
                return Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsHistory(
                            result: result,
                            id: sortedDocuments[index].id,
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
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('results')
                              .doc(sortedDocuments[index].id)
                              .delete();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height:
                            0.0, // set the height to 0.0 to remove extra space
                        thickness:
                            3.0, // set the thickness to the desired value
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}
