import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.height,
      this.expand = false,
      this.hintText = '',
      required this.title,
      required this.controller});

  final double? height;
  final bool expand;
  final String hintText;
  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        expands: expand,
        maxLines: null,
        cursorColor: seccol,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: GoogleFonts.urbanist(
            textStyle: const TextStyle(
              color: seccol,
              fontSize: 19,
              fontWeight: FontWeight.w600
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: tercol),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: seccol, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          hoverColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
