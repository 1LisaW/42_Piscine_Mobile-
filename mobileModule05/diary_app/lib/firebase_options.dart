// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Firebase options loaded from [assets/env/firebase.env] after [dotenv.load].
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

  static String _v(String key) => dotenv.get(key);

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _v('FIREBASE_WEB_API_KEY'),
    appId: _v('FIREBASE_WEB_APP_ID'),
    messagingSenderId: _v('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _v('FIREBASE_PROJECT_ID'),
    authDomain: _v('FIREBASE_AUTH_DOMAIN'),
    storageBucket: _v('FIREBASE_STORAGE_BUCKET'),
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _v('FIREBASE_ANDROID_API_KEY'),
    appId: _v('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: _v('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _v('FIREBASE_PROJECT_ID'),
    storageBucket: _v('FIREBASE_STORAGE_BUCKET'),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _v('FIREBASE_IOS_API_KEY'),
    appId: _v('FIREBASE_IOS_APP_ID'),
    messagingSenderId: _v('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _v('FIREBASE_PROJECT_ID'),
    storageBucket: _v('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: _v('FIREBASE_IOS_BUNDLE_ID'),
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: _v('FIREBASE_IOS_API_KEY'),
    appId: _v('FIREBASE_IOS_APP_ID'),
    messagingSenderId: _v('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _v('FIREBASE_PROJECT_ID'),
    storageBucket: _v('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: _v('FIREBASE_IOS_BUNDLE_ID'),
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: _v('FIREBASE_WINDOWS_API_KEY'),
    appId: _v('FIREBASE_WINDOWS_APP_ID'),
    messagingSenderId: _v('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _v('FIREBASE_PROJECT_ID'),
    authDomain: _v('FIREBASE_AUTH_DOMAIN'),
    storageBucket: _v('FIREBASE_STORAGE_BUCKET'),
  );
}
