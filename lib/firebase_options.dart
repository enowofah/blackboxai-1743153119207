import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBeK6h96wQOwBLRTlghTZ2m6hy22bwCFjM',
    appId: '1:941867004596:web:6a909d55e3b04cdca75de1',
    messagingSenderId: '941867004596',
    projectId: 'tripmate-21e3f',
    authDomain: 'tripmate-21e3f.firebaseapp.com',
    storageBucket: 'tripmate-21e3f.appspot.com',
    measurementId: 'G-XXXXXXXXXX', // You'll need to add this from Firebase Console
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeK6h96wQOwBLRTlghTZ2m6hy22bwCFjM',
    appId: '1:941867004596:android:6a909d55e3b04cdca75de1',
    messagingSenderId: '941867004596',
    projectId: 'tripmate-21e3f',
    storageBucket: 'tripmate-21e3f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'tripmate-12345',
    storageBucket: 'tripmate-12345.appspot.com',
    iosBundleId: 'com.example.tripmate',
  );
}