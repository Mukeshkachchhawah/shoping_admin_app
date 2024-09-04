// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB4bXHiVAfO2evKyMM4Ak68slfUuMMNk-0',
    appId: '1:558016054403:web:706454a464ae5ae4d307b6',
    messagingSenderId: '558016054403',
    projectId: 'e-commerece-935b2',
    authDomain: 'e-commerece-935b2.firebaseapp.com',
    storageBucket: 'e-commerece-935b2.appspot.com',
    measurementId: 'G-P3YG8VHTWB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAko21cQAxhy7-h-vRyyzBJ68zJ5L8MIu0',
    appId: '1:558016054403:android:ed7f32d772c539edd307b6',
    messagingSenderId: '558016054403',
    projectId: 'e-commerece-935b2',
    storageBucket: 'e-commerece-935b2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUYw3wKy23zk7nShaMa6hOW1JJr7Nwn3k',
    appId: '1:558016054403:ios:195336fda5665521d307b6',
    messagingSenderId: '558016054403',
    projectId: 'e-commerece-935b2',
    storageBucket: 'e-commerece-935b2.appspot.com',
    iosBundleId: 'com.example.shopingAppAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUYw3wKy23zk7nShaMa6hOW1JJr7Nwn3k',
    appId: '1:558016054403:ios:195336fda5665521d307b6',
    messagingSenderId: '558016054403',
    projectId: 'e-commerece-935b2',
    storageBucket: 'e-commerece-935b2.appspot.com',
    iosBundleId: 'com.example.shopingAppAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB4bXHiVAfO2evKyMM4Ak68slfUuMMNk-0',
    appId: '1:558016054403:web:6abdf4fa02867f59d307b6',
    messagingSenderId: '558016054403',
    projectId: 'e-commerece-935b2',
    authDomain: 'e-commerece-935b2.firebaseapp.com',
    storageBucket: 'e-commerece-935b2.appspot.com',
    measurementId: 'G-3S3BEWFSMJ',
  );
}
