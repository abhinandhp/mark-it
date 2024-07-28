import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/pages/bottomnavpage.dart';
import 'package:mark_it/pages/signup_page.dart';
import 'package:mark_it/widgets/mytextfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  void onTap() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpPage(),
        ));
  }

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const SpinKitThreeBounce(
              color: Colors.black,
              size: 30,
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passcontroller.text,
      );
      if (mounted) {
        Navigator.pop(context);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pricol,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 280,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8),
                child: MyTextField(
                  controller: emailcontroller,
                  title: 'email',
                  colo: bgcol,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8),
                child: MyTextField(
                  controller: passcontroller,
                  title: 'password',
                  obsctext: true,
                  colo: bgcol,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8),
                child: GestureDetector(
                  onTap: login,
                  child: Material(
                    elevation: 4,
                    shadowColor: bgcol,
                    borderRadius: BorderRadius.circular(15),
                    color: tercol,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      child: Center(
                        child: Text(
                          'Sign In',
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
                child: const Text("Dont have an account? Sign Up Here",style: TextStyle(
                  color: bgcol
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
