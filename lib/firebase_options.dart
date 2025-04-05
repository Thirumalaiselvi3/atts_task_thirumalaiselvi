// firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure using flutterfire CLI.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFByN2o7PHWEU19vtCi2ISLeZXmAC3gPo',
    appId: '1:428680324514:android:47c3e3ba23a7c0630b7efb',
    messagingSenderId: '428680324514',
    projectId: 'flutter-login-557e8',
    storageBucket: 'flutter-login-557e8.appspot.com',
  );
}
