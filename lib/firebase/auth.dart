import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mark_it/pages/bottomnavpage.dart';
import 'package:mark_it/pages/loginpage.dart';




class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const MainPage();
          }
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}