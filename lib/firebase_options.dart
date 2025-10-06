import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key-web',
    appId: '1:000000000000:web:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    authDomain: 'senioren-app-demo.firebaseapp.com',
    storageBucket: 'senioren-app-demo.appspot.com',
    measurementId: 'G-DEMO12345',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key-android',
    appId: '1:000000000000:android:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    storageBucket: 'senioren-app-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key-ios',
    appId: '1:000000000000:ios:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    storageBucket: 'senioren-app-demo.appspot.com',
    iosBundleId: 'com.example.seniorenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key-macos',
    appId: '1:000000000000:macos:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    storageBucket: 'senioren-app-demo.appspot.com',
    iosBundleId: 'com.example.seniorenApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-api-key-windows',
    appId: '1:000000000000:windows:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    storageBucket: 'senioren-app-demo.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'demo-api-key-linux',
    appId: '1:000000000000:linux:demoapp',
    messagingSenderId: '000000000000',
    projectId: 'senioren-app-demo',
    storageBucket: 'senioren-app-demo.appspot.com',
  );
}
