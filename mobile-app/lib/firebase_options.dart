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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHmLsPsox2Ql4fMhX1lgfhmDdxd61g3Og',
    appId: '1:279996938146:android:f4f1dc370f9ccc4355e4fb',
    messagingSenderId: '279996938146',
    projectId: 'tranquilestate-147f6',
    storageBucket: 'tranquilestate-147f6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0JyHR-uBn8ESY53w9AUkCD6pRyOocjho',
    appId: '1:279996938146:ios:df5c70ea5bf8a5ce55e4fb',
    messagingSenderId: '279996938146',
    projectId: 'tranquilestate-147f6',
    storageBucket: 'tranquilestate-147f6.firebasestorage.app',
    androidClientId:
        '279996938146-8cbq3ripeid0bbbit32cp7ih9383agpg.apps.googleusercontent.com',
    iosClientId:
        '279996938146-qtepmehk7qk2lg9m2vvg61fuhhakdvd3.apps.googleusercontent.com',
    iosBundleId: 'com.tranquilestate.ios',
  );
}
