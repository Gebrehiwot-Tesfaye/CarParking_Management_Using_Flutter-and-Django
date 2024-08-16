import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String?) onSaved;

  const CustomTextField({
    required this.labelText,
    this.initialValue,
    this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
