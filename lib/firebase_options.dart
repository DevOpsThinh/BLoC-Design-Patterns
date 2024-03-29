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
///

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
    apiKey: 'AIzaSyAfmFVscL73HSyjjr-aZukfeYDQBuday8Q',
    appId: '1:352578080200:web:82311b0270a56016ddc4fd',
    messagingSenderId: '352578080200',
    projectId: 'android-programming-dda72',
    authDomain: 'android-programming-dda72.firebaseapp.com',
    databaseURL: 'https://android-programming-dda72-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'android-programming-dda72.appspot.com',
    measurementId: 'G-149F5F72WK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfqdieQG6ir3x7DtbbZE4mZPuMC9ZMvP4',
    appId: '1:352578080200:android:7d5ecd30c61c1b16ddc4fd',
    messagingSenderId: '352578080200',
    projectId: 'android-programming-dda72',
    databaseURL: 'https://android-programming-dda72-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'android-programming-dda72.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8MwGldupiHpWwz05o0vZwgHKFMTSom9I',
    appId: '1:352578080200:ios:bbf6b93ceb600d9fddc4fd',
    messagingSenderId: '352578080200',
    projectId: 'android-programming-dda72',
    databaseURL: 'https://android-programming-dda72-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'android-programming-dda72.appspot.com',
    androidClientId: '352578080200-ed9mlr0r4201v5jr541uk6m7esh012fp.apps.googleusercontent.com',
    iosClientId: '352578080200-sv4udmc5lua4ioqs4ghkr9f21hoig8e1.apps.googleusercontent.com',
    iosBundleId: 'com.example.counterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8MwGldupiHpWwz05o0vZwgHKFMTSom9I',
    appId: '1:352578080200:ios:bbf6b93ceb600d9fddc4fd',
    messagingSenderId: '352578080200',
    projectId: 'android-programming-dda72',
    databaseURL: 'https://android-programming-dda72-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'android-programming-dda72.appspot.com',
    androidClientId: '352578080200-ed9mlr0r4201v5jr541uk6m7esh012fp.apps.googleusercontent.com',
    iosClientId: '352578080200-sv4udmc5lua4ioqs4ghkr9f21hoig8e1.apps.googleusercontent.com',
    iosBundleId: 'com.example.counterApp',
  );
}
