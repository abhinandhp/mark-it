import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mark_it/firebase_options.dart';
//import 'package:mark_it/mongodb/mongodb.dart';
import 'package:mark_it/pages/homepage.dart';


Future<void> main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
 // await MongoDb().connect();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:HomePage()    );
  }
}