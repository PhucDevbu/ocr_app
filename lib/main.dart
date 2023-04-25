import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocr_app/firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocr_app/provider/image_file_provider.dart';
import 'package:ocr_app/screen/home_page.dart';
import 'package:ocr_app/screen/image_form_page.dart';

import 'package:provider/provider.dart';

import 'screen/details_page.dart';
import 'screen/email_auth/login_screen.dart';
import 'screen/home_screen.dart';
import 'screen/phone_auth/sign_in_with_phone.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

// Add a new document with a generated ID
  FirebaseFirestore.instance.collection("users").add(user).then(
      (DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));

  await FirebaseFirestore.instance.collection("users").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });
  // QuerySnapshot querySnapshot =
  //     await FirebaseFirestore.instance.collection("users").get();
  // for (var doc in querySnapshot.docs) {
  //   log(doc.data().toString());
  // }
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? HomeScreen()
          : SignInWithPhone(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//         designSize: const Size(360, 690),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) {
//           return ChangeNotifierProvider(
//             create: (context)=>ImageFile(),
//             child: MaterialApp(
//               title: 'Image Picker Demo',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 primarySwatch: Colors.blue,
//                 scaffoldBackgroundColor: Colors.white,
//                 appBarTheme: const AppBarTheme(
//                   backgroundColor: Colors.white,
//                   foregroundColor: Colors.black,
//                   iconTheme: IconThemeData(color: Colors.black),
//                   elevation: 0,
//                 ),
//                 elevatedButtonTheme: ElevatedButtonThemeData(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                     textStyle: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//               home: const HomePage(),
//               routes: {
//                 ImageFormPage.routeName: (context) => const ImageFormPage(),
//                 DetailsPage.routeName: (context) => const DetailsPage(),
//               },
//             ),
//           );
//         });
//   }
// }
