import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  const InputField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: true,
        obscureText: obscureText,
        validator: (value) {
          if (hintText.trim() == 'Address Line 2 (Optional)') {
            return null;
          } else if (value!.trim().isEmpty) {
            return 'Please enter the $hintText!';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
