import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool isObsecureText;
  final TextEditingController controller;

  const AuthField({
    super.key,
    required this.hintText,
    this.isObsecureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
      obscureText: isObsecureText,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
