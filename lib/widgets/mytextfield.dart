import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.height,
      this.expand = false,
      this.hintText = '',
      required this.title
      //required this.controller
      });

  final double? height;
  final bool expand;
  final String hintText;
  final String title;
  //final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
        TextField(
          //controller: controller,
          expands: expand,
          maxLines: null,
          cursorColor: Colors.green,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            hoverColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
