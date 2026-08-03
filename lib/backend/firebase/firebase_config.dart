import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCYOHV0Oro9_k9rdCpBqpmULICnZB-nHLc",
            authDomain: "the-50-yard-challenge.firebaseapp.com",
            projectId: "the-50-yard-challenge",
            storageBucket: "the-50-yard-challenge.firebasestorage.app",
            messagingSenderId: "647139469389",
            appId: "1:647139469389:web:0a0026d791c21cb5975404",
            measurementId: "G-6LPKL6JV1X"));
  } else {
    await Firebase.initializeApp();
  }
}
