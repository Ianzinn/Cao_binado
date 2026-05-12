// GENERATED FILE — DO NOT EDIT MANUALLY
//
// Run the following command to regenerate this file with your real
// Firebase project credentials:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Until then, this placeholder prevents compile errors.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions: unsupported platform. '
          'Run `flutterfire configure` to generate real options.',
        );
    }
  }

  // Replace ALL values below with the output of `flutterfire configure`
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_MDmP8pUwgNXfEzE8c9pgCiSxsEsVRw0',
    appId: '1:972810750283:android:58153fdc7149b4d3b640ce',
    messagingSenderId: '972810750283',
    projectId: 'cao-binado',
    storageBucket: 'cao-binado.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv9WjwAiw9uo889lxUG353bt1wcU7kIs4',
    appId: '1:972810750283:ios:47648f6e8340fef4b640ce',
    messagingSenderId: '972810750283',
    projectId: 'cao-binado',
    storageBucket: 'cao-binado.firebasestorage.app',
    iosBundleId: 'com.example.caoBinado',
  );
}