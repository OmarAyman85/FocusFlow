import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final bool isObscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;

  const AppTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.isObscureText = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, hintText: hintText),
    );
  }
}
