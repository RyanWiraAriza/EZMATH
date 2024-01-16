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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC5IjR2rbm9p1DOehRm1Jqx_kd19hGBCes',
    appId: '1:195728888536:web:a25530e63a07570c477dad',
    messagingSenderId: '195728888536',
    projectId: 'ezmath-9d2a6',
    authDomain: 'ezmath-9d2a6.firebaseapp.com',
    storageBucket: 'ezmath-9d2a6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADep4TU6jltJc8jhCO2PSgCYq8usRNA8g',
    appId: '1:195728888536:android:b71595f5b7fca594477dad',
    messagingSenderId: '195728888536',
    projectId: 'ezmath-9d2a6',
    storageBucket: 'ezmath-9d2a6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfmoS7dmfZm0Ua_3paxo4we-tS3_cuMXo',
    appId: '1:195728888536:ios:c9928eb0af52dcf2477dad',
    messagingSenderId: '195728888536',
    projectId: 'ezmath-9d2a6',
    storageBucket: 'ezmath-9d2a6.appspot.com',
    iosBundleId: 'com.easymath.ryan.easymath',
  );
}
