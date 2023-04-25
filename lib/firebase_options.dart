// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-3ftVPaDhnWRBmjaGqiGG0OPVFhtgkR4',
    appId: '1:439411696361:web:aa5e6a70424e6358cdc678',
    messagingSenderId: '439411696361',
    projectId: 'ocrapp-31c0d',
    authDomain: 'ocrapp-31c0d.firebaseapp.com',
    storageBucket: 'ocrapp-31c0d.appspot.com',
    measurementId: 'G-45EXB3RJ55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCg7GmN8bgszXTqWTcaTN_U-DCTVmMnGi4',
    appId: '1:439411696361:android:c95a20a47ab0db21cdc678',
    messagingSenderId: '439411696361',
    projectId: 'ocrapp-31c0d',
    storageBucket: 'ocrapp-31c0d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBG-sMmGtYLeDRCsGHHRa9Jjm9SSUDkqK8',
    appId: '1:439411696361:ios:d813d2b9af218f3dcdc678',
    messagingSenderId: '439411696361',
    projectId: 'ocrapp-31c0d',
    storageBucket: 'ocrapp-31c0d.appspot.com',
    iosClientId: '439411696361-agbfosu1k1eu26dan70qugl5o335egh0.apps.googleusercontent.com',
    iosBundleId: 'com.example.ocrApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBG-sMmGtYLeDRCsGHHRa9Jjm9SSUDkqK8',
    appId: '1:439411696361:ios:d813d2b9af218f3dcdc678',
    messagingSenderId: '439411696361',
    projectId: 'ocrapp-31c0d',
    storageBucket: 'ocrapp-31c0d.appspot.com',
    iosClientId: '439411696361-agbfosu1k1eu26dan70qugl5o335egh0.apps.googleusercontent.com',
    iosBundleId: 'com.example.ocrApp',
  );
}
