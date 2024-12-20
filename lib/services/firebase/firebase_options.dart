import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
    apiKey: 'AIzaSyB8uvY858rOo4ziXhl17UcrE6f4aVS5jZ8',
    appId: '1:11351257467:web:236bae416bea30ed3c8dde',
    messagingSenderId: '11351257467',
    projectId: 'task-management-app-flut-68cdf',
    authDomain: 'task-management-app-flut-68cdf.firebaseapp.com',
    storageBucket: 'task-management-app-flut-68cdf.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9NAs6w8G_jv77HxUx3P5XoREtso4gAHM',
    appId: '1:11351257467:android:8982a712599f4c373c8dde',
    messagingSenderId: '11351257467',
    projectId: 'task-management-app-flut-68cdf',
    storageBucket: 'task-management-app-flut-68cdf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlu4-a0Qs1SJhEni0QMAz2UplLDe9qDZQ',
    appId: '1:11351257467:ios:1731341c3466411c3c8dde',
    messagingSenderId: '11351257467',
    projectId: 'task-management-app-flut-68cdf',
    storageBucket: 'task-management-app-flut-68cdf.appspot.com',
    iosBundleId: 'com.example.taskManagementApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlu4-a0Qs1SJhEni0QMAz2UplLDe9qDZQ',
    appId: '1:11351257467:ios:1731341c3466411c3c8dde',
    messagingSenderId: '11351257467',
    projectId: 'task-management-app-flut-68cdf',
    storageBucket: 'task-management-app-flut-68cdf.appspot.com',
    iosBundleId: 'com.example.taskManagementApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8uvY858rOo4ziXhl17UcrE6f4aVS5jZ8',
    appId: '1:11351257467:web:b1d49bb8d8dea4253c8dde',
    messagingSenderId: '11351257467',
    projectId: 'task-management-app-flut-68cdf',
    authDomain: 'task-management-app-flut-68cdf.firebaseapp.com',
    storageBucket: 'task-management-app-flut-68cdf.appspot.com',
  );
}
