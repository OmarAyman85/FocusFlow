import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusflow/injection_container.dart';
import 'firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensures Flutter engine is fully initialized before calling async code like Firebase init.

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initializes Firebase using platform-specific configuration (Android/iOS/web).
  // `DefaultFirebaseOptions` is generated based on your Firebase project setup.

  await init();
  // Calls your custom function to register all dependencies with GetIt (e.g., use cases, repositories).

  runApp(const MyApp());
}
