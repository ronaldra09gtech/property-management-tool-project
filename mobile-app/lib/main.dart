import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tranquilestate/app.dart';
import 'package:tranquilestate/firebase_options.dart';

Future<void> main() async {
  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Load all the Material Design / Themes / Localizations / Bindings
  runApp(const App());
}
