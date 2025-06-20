import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData icon;
  final bool isObscureText;
  const Field({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        enabled: true,
        obscureText: isObscureText,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return 'Please enter the $text';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: text,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
