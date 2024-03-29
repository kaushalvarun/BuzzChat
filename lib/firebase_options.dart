// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'secrets.dart';

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
    apiKey: fwApiKey,
    appId: fwAppId,
    messagingSenderId: fwMessagingSenderId,
    projectId: fwProjectId,
    authDomain: fwAuthDomain,
    storageBucket: fwStorageBucket,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: faApiKey,
    appId: faAppId,
    messagingSenderId: faMessagingSenderId,
    projectId: faProjectId,
    storageBucket: faStorageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: fiApiKey,
    appId: fiAppId,
    messagingSenderId: fiMessagingSenderId,
    projectId: fiProjectId,
    storageBucket: fiStorageBucket,
    iosClientId: fiIosClientId,
    iosBundleId: fiIosBundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: fmApiKey,
    appId: fmAppId,
    messagingSenderId: fmMessagingSenderId,
    projectId: fmProjectId,
    storageBucket: fmStorageBucket,
    iosClientId: fmIosClientId,
    iosBundleId: fmIosBundleId,
  );
}
