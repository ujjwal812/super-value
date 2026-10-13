import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBi-q86F9U1dcD_2wWjhhLewtwfVwaMb8E',
    appId: '1:612768338922:android:8842ebef3f673049215893',
    messagingSenderId: '612768338922',
    projectId: 'learningproject-ac49e',
    storageBucket: 'learningproject-ac49e.firebasestorage.app',
  );
}
