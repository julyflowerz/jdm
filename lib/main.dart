import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jdm/car_list_screen.dart';
import 'package:jdm/gamescreen.dart';

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
      debugShowCheckedModeBanner: false,
      title: '2D Racing Game',
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/carlist': (context) => const CarListScreen(),
        //  removed '/game' route because GameScreen requires arguments
      },
    );


  }
}
