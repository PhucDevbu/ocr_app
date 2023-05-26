import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ocr_app/screen/details_page.dart';
import 'package:ocr_app/screen/image_form_page.dart';
import 'package:ocr_app/screen/text_detector_view.dart';
import '../model/image_app.dart';
import 'email_auth/user_profile_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<int> getFileSize(String url) async {
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) {
      final headers = response.headers;
      if (headers.containsKey('content-length')) {
        return int.parse(headers['content-length']!);
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Image'),
              onPressed: () {
                Navigator.pushNamed(context, ImageFormPage.routeName);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Màu icon và label
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black), // Màu nền
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent), // Màu nền khi nhấn
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextRecognizerView()),
                );
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Màu icon và label
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black), // Màu nền
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent), // Màu nền khi nhấn
              ),
            )
          ],
        ),
        appBar: AppBar(
          title: const Text('ORC App'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserProfileScreen()));
              },
              icon: const Icon(Icons.account_circle),
            ),
          ],
        ),
        body: Column(
          children: [
            Text(
              "My Image",
              style: TextStyle(fontSize: 20.sp),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 5.0, // set the height to 0.0 to remove extra space
                thickness: 3.0, // set the thickness to the desired value
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('images')
                  .where('uId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs;
                final sortedDocuments = documents.toList();
                sortedDocuments
                    .sort((a, b) => b['createAt'].compareTo(a['createAt']));
                return Expanded(
                  child: Container(
                    color: const Color(0xfff3f2f2),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var imageApp =
                            ImageApp.fromMap(sortedDocuments[index].data());

                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  DetailsPage.routeName,
                                  arguments: ImageApp(
                                      createAt: sortedDocuments[index]
                                          ['createAt'],
                                      title: sortedDocuments[index]['title'],
                                      uId: sortedDocuments[index]['uId'],
                                      url: sortedDocuments[index]['url']),
                                ),
                                leading: ClipRRect(
                                  child: Image.network(
                                    imageApp.url,
                                    fit: BoxFit.cover,
                                    height: 50.h,
                                    width: 50.h,
                                  ),
                                ),
                                title: Text(
                                  imageApp.title,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Created at ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(imageApp.createAt))}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('images')
                                        .doc(sortedDocuments[index].id)
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  iconSize: 30.0,
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
                          ),
                        );
                      },
                      itemCount: sortedDocuments.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
