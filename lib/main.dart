
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ocr_app/provider/image_file_provider.dart';
import 'package:ocr_app/screen/home_page.dart';
import 'package:ocr_app/screen/image_form_page.dart';

import 'package:provider/provider.dart';


import 'screen/details_page.dart';
List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ChangeNotifierProvider(
            create: (context)=>ImageFile(),
            child: MaterialApp(
              title: 'Image Picker Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              home: const HomePage(),
              routes: {
                ImageFormPage.routeName: (context) => const ImageFormPage(),
                DetailsPage.routeName: (context) => const DetailsPage(),
              },
            ),
          );
        });
  }
}
