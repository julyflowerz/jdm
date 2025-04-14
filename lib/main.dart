// Flutter core
import 'package:flutter/material.dart';

// Firebase core
import 'package:firebase_core/firebase_core.dart';

// Your custom screens
import 'startscreen.dart';          // Custom start screen UI
import 'firebase_options.dart';     // Firebase configuration (auto-generated)

void main() async {
  // Ensures Flutter bindings are ready before using async methods like Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Launch the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2D Racing Game',
      debugShowCheckedModeBanner: false, // Removes the debug banner in the top-right
      home: const StartScreen(),         // First screen shown when app starts
    );
  }
}
