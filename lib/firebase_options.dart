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
    apiKey: 'AIzaSyDOJPsfNd9UpQzGrc_sU8ebavPZQP3aLY0',
    appId: '1:106769893211:web:1dec0d90d65c9ca0e43c7e',
    messagingSenderId: '106769893211',
    projectId: 'breathin-24eff',
    authDomain: 'breathin-24eff.firebaseapp.com',
    storageBucket: 'breathin-24eff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHhikZ3hYiLUOGXSdUI_Sz-xCkjw_pw58',
    appId: '1:106769893211:android:a9168af90e63a876e43c7e',
    messagingSenderId: '106769893211',
    projectId: 'breathin-24eff',
    storageBucket: 'breathin-24eff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMsn5wX7YThBJN0fbCU1xkzOtXjGrFqdg',
    appId: '1:106769893211:ios:cfb00992a2bcac22e43c7e',
    messagingSenderId: '106769893211',
    projectId: 'breathin-24eff',
    storageBucket: 'breathin-24eff.appspot.com',
    androidClientId: '106769893211-42217977oteh6oo9k497sgfj5kal0tif.apps.googleusercontent.com',
    iosClientId: '106769893211-pu75hu9q876ka7p0hl06i15ai17b9fqj.apps.googleusercontent.com',
    iosBundleId: 'com.example.iosNotificationTask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMsn5wX7YThBJN0fbCU1xkzOtXjGrFqdg',
    appId: '1:106769893211:ios:cfb00992a2bcac22e43c7e',
    messagingSenderId: '106769893211',
    projectId: 'breathin-24eff',
    storageBucket: 'breathin-24eff.appspot.com',
    androidClientId: '106769893211-42217977oteh6oo9k497sgfj5kal0tif.apps.googleusercontent.com',
    iosClientId: '106769893211-pu75hu9q876ka7p0hl06i15ai17b9fqj.apps.googleusercontent.com',
    iosBundleId: 'com.example.iosNotificationTask',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBVs8X0Y7qgYD7pTCiYdae0QZ2e0jb7e3Q',
    appId: '1:106769893211:web:1b957a091c31ad09e43c7e',
    messagingSenderId: '106769893211',
    projectId: 'breathin-24eff',
    authDomain: 'breathin-24eff.firebaseapp.com',
    storageBucket: 'breathin-24eff.appspot.com',
  );
}
