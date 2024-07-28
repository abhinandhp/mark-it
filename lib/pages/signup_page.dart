import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/pages/loginpage.dart';
import 'package:mark_it/widgets/mytextfield.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();

  void onTap() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  void signup() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (passcontroller.text != confirmpasscontroller.text) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords does not match'),
        ),
      );
    } else {
      try {
        // ignore: unused_local_variable
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text,
          password: passcontroller.text,
        );
        await createUserDoc(userCredential);
        if (mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Account created successfully'),
            ),
          );

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.code),
            ),
          );
        }
      }
    }
  }

  Future<void> createUserDoc(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential
                .user!.uid) // Use UID instead of email for the document ID
            .set({
          'email': userCredential.user!.email,
          'username': usernamecontroller.text,
          'uid': userCredential.user!.uid
        });
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pricol,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 230,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                controller: usernamecontroller,
                title: 'username',
                colo: bgcol,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                controller: emailcontroller,
                title: 'email',
                colo: bgcol,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                  controller: passcontroller,
                  title: 'password',
                  colo: bgcol,
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                colo: bgcol,
                controller: confirmpasscontroller,
                title: 'Confirm password',
                obsctext: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: signup,
                child: Material(
                  elevation: 4,
                  shadowColor: bgcol,
                  borderRadius: BorderRadius.circular(15),
                  color: tercol,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                            color: pricol,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: const Text(
                "Already have an account? Login Here",
                style: TextStyle(color: bgcol),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
