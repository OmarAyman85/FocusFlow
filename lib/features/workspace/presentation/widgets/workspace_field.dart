import 'package:flutter/material.dart';

class LabeledTextFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;

  const LabeledTextFormField({
    super.key,
    required this.label,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
    );
  }
}
