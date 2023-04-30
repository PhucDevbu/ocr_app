import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocr_app/screen/details_page.dart';
import 'package:ocr_app/screen/image_form_page.dart';
import 'package:ocr_app/screen/text_detector_view.dart';
import 'package:provider/provider.dart';
import '../model/image_app.dart';
import '../provider/image_file_provider.dart' as ima;
import 'email_auth/user_profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.image),
              onPressed: () {
                Navigator.pushNamed(context, ImageFormPage.routeName);
              },
              heroTag: "fab1",
            ),
            FloatingActionButton(
              child: const Icon(Icons.camera),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextRecognizerView(),
                  ),
                );
              },
              heroTag: "fab2",
            ),
          ],
        ),
        appBar: AppBar(
          title: Text('ORC App'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserProfileScreen()));
              },
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('images')
                .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              List<ImageApp> images = [];
              QuerySnapshot querySnapshot = snapshot.data!;
              images = querySnapshot.docs
                  .map((doc) =>
                      ImageApp.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();
              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DetailsPage.routeName,
                          arguments: ImageApp(
                              createAt: documents[i]['createAt'],
                              title: documents[i]['title'],
                              uId: documents[i]['uId'],
                              url: documents[i]['url']),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.network(
                              documents[i]['url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('images')
                                      .doc(documents[i].id)
                                      .delete();
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          Text(
                            documents[i]['title'],
                            style:
                                TextStyle(fontSize: 30.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: documents.length,
              );
            },
          ),
        ));
    // FutureBuilder(
    //   future:
    //       Provider.of<ima.ImageFile>(context, listen: false).fetchImage(),
    //   builder: (context, snapshot) =>
    //       snapshot.connectionState == ConnectionState.waiting
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : Consumer<ima.ImageFile>(
    //               child: Center(child: Text("Start add your story")),
    //               builder: (context, image, child) => image.items.isEmpty
    //                   ? Container()
    //                   : GridView.builder(
    //                       gridDelegate:
    //                           const SliverGridDelegateWithFixedCrossAxisCount(
    //                               crossAxisCount: 1,
    //                               childAspectRatio: 3 / 2,
    //                               crossAxisSpacing: 10,
    //                               mainAxisSpacing: 10),
    //                       itemBuilder: (context, i) => Padding(
    //                         padding: EdgeInsets.all(16.sp),
    //                         child: GridTile(
    //                           child: GestureDetector(
    //                             onTap: () {
    //                               Navigator.pushNamed(
    //                                   context, DetailsPage.routeName,
    //                                   arguments: image.items[i]);
    //                             },
    //                             child: ClipRRect(
    //                               borderRadius: BorderRadius.circular(20.r),
    //                               child: Image.file(
    //                                 image.items[i].image,
    //                                 fit: BoxFit.cover,
    //                               ),
    //                             ),
    //                           ),
    //                           header: Row(
    //                             mainAxisAlignment: MainAxisAlignment.end,
    //                             children: [
    //                               IconButton(
    //                                 onPressed: () =>
    //                                     Provider.of<ima.ImageFile>(context,
    //                                             listen: false)
    //                                         .deleteImage(image.items[i]),
    //                                 icon: Icon(Icons.delete),
    //                                 color: Colors.red,
    //                               )
    //                             ],
    //                           ),
    //                           footer: GridTileBar(
    //                             leading: Text(
    //                               image.items[i].title,
    //                               style: TextStyle(
    //                                   fontSize: 30.sp, color: Colors.white),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       itemCount: image.items.length,
    //                     ),
    //             ),
    // ));
  }
}
