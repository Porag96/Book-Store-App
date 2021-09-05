import 'package:flutter/material.dart';

class CustomTextInputs extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  bool isPassword = true;

  CustomTextInputs(
      {required this.controller,
      required this.iconData,
      required this.hintText,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      // /margin: EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(),
            ),
            prefixIcon: Icon(
              iconData,
              color: Colors.red,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
